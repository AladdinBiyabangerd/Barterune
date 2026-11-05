package appbackend.barterune.billing

import kotlinx.coroutines.runBlocking
import org.junit.Assert.*
import org.junit.Test
import java.io.IOException

class BillingCoordinatorTest {
    private class TestSessions : Sessions {
        var value: BillingSession? = BillingSession("alice", "login-1")
        override fun current() = value
        override suspend fun idToken(session: BillingSession) = "unused-test-token"
    }
    private class Journal : PurchaseJournal {
        val bindings = mutableMapOf<String, String>()
        val queue = mutableListOf<QueuedPurchase>()
        val cache = mutableMapOf<String, Set<String>>()
        var failWrite = false
        var onReadEntitlements: (() -> Unit)? = null
        override fun identity(uid: String) = bindings[uid]
        override fun bind(uid: String, accountId: String) { bindings[uid] = accountId }
        override fun queue(purchase: QueuedPurchase) {
            if (failWrite) throw IOException("disk full")
            if (queue.none { it.uid == purchase.uid && it.token == purchase.token }) queue += purchase
        }
        override fun pending(uid: String) = queue.filter { it.uid == uid }
        override fun remove(purchase: QueuedPurchase) { queue.remove(purchase) }
        override fun entitlements(uid: String): Set<String> {
            val values = cache[uid].orEmpty()
            onReadEntitlements?.invoke()
            return values
        }
        override fun replaceEntitlements(uid: String, values: Set<String>) { cache[uid] = values }
        override fun clear(uid: String) { bindings.remove(uid); cache.remove(uid); queue.removeAll { it.uid == uid } }
    }
    private class Backend(private val journal: Journal) : BillingBackend {
        var packageName = "com.test.barterune"
        var verificationFailure: Exception? = null
        var onVerify: (() -> Unit)? = null
        var calls = 0
        var right = setOf("caravan_skin")
        override suspend fun catalog(session: BillingSession) = BillingCatalog("barterune", packageName, setOf("skin"))
        override suspend fun identity(session: BillingSession) = if (session.uid == "alice") "a".repeat(64) else "b".repeat(64)
        override suspend fun verify(session: BillingSession, purchase: QueuedPurchase) {
            assertTrue("purchase must be durable before request", purchase in journal.queue)
            assertEquals(session.uid, purchase.uid)
            calls++
            onVerify?.invoke()
            verificationFailure?.let { throw it }
        }
        override suspend fun entitlements(session: BillingSession) = right
    }
    private class Fixture {
        val sessions = TestSessions()
        val journal = Journal()
        val backend = Backend(journal)
        fun coordinator() = BillingCoordinator(sessions, backend, journal, "com.test.barterune")
        val processor = coordinator()
        fun event(account: String? = "a".repeat(64), purchased: Boolean = true) = PurchaseEvent("skin", "test-purchase-token", account, purchased)
    }
    @Test fun pendingNeverVerifiesOrGrants() = runBlocking {
        val f = Fixture(); f.processor.accept(f.event(purchased = false))
        assertEquals(0, f.backend.calls); assertTrue(f.journal.queue.isEmpty()); assertTrue(f.processor.activeEntitlements().isEmpty())
    }
    @Test fun wrongAccountCannotTransferPurchase() = runBlocking {
        val f = Fixture(); f.processor.prepare("skin")
        try { f.processor.accept(f.event("b".repeat(64))); fail() } catch (_: PurchaseDenied) { }
        assertEquals(0, f.backend.calls); assertTrue(f.journal.queue.isEmpty())
    }
    @Test fun missingAccountIdentifierIsDenied() = runBlocking {
        val f = Fixture(); f.processor.prepare("skin")
        try { f.processor.accept(f.event(null)); fail() } catch (_: PurchaseDenied) { }
        assertEquals(0, f.backend.calls)
    }
    @Test fun onlyServerEntitlementsAreGranted() = runBlocking {
        val f = Fixture(); f.processor.prepare("skin"); f.processor.accept(f.event())
        assertEquals(setOf("caravan_skin"), f.processor.activeEntitlements()); assertTrue(f.journal.queue.isEmpty())
    }
    @Test fun networkFailureRetainsPurchaseForNewProcess() = runBlocking {
        val f = Fixture(); f.processor.prepare("skin"); f.backend.verificationFailure = IOException("offline")
        try { f.processor.accept(f.event()); fail() } catch (_: IOException) { }
        assertEquals(1, f.journal.queue.size); assertTrue(f.processor.activeEntitlements().isEmpty())
        f.backend.verificationFailure = null
        f.coordinator().refresh()
        assertEquals(2, f.backend.calls); assertTrue(f.journal.queue.isEmpty()); assertEquals(setOf("caravan_skin"), f.processor.activeEntitlements())
    }
    @Test fun accountSwitchDuringVerificationNeverGrantsToNewAccount() = runBlocking {
        val f = Fixture(); f.processor.prepare("skin")
        f.backend.onVerify = { f.sessions.value = BillingSession("bob", "login-2") }
        try { f.processor.accept(f.event()); fail() } catch (_: AccountChanged) { }
        assertTrue(f.processor.activeEntitlements().isEmpty()); assertEquals(1, f.journal.pending("alice").size)
    }
    @Test fun sameUidNewLoginEpochRejectsOldResponse() = runBlocking {
        val f = Fixture(); f.processor.prepare("skin")
        f.backend.onVerify = { f.sessions.value = BillingSession("alice", "new-login") }
        try { f.processor.accept(f.event()); fail() } catch (_: AccountChanged) { }
        assertTrue(f.processor.activeEntitlements().isEmpty())
    }
    @Test fun durableWriteFailureStopsVerification() = runBlocking {
        val f = Fixture(); f.processor.prepare("skin"); f.journal.failWrite = true
        try { f.processor.accept(f.event()); fail() } catch (_: IOException) { }
        assertEquals(0, f.backend.calls)
    }
    @Test fun foreignPackageAndUnknownProductCannotStartCheckout() = runBlocking {
        val f = Fixture(); f.backend.packageName = "com.other.app"
        try { f.processor.prepare("skin"); fail() } catch (_: PurchaseDenied) { }
        f.backend.packageName = "com.test.barterune"
        try { f.processor.prepare("unknown"); fail() } catch (_: PurchaseDenied) { }
    }
    @Test fun logoutHidesOldCacheAndBlocksStaleCheckout() = runBlocking {
        val f = Fixture(); val checkout = f.processor.prepare("skin"); f.processor.accept(f.event())
        f.sessions.value = null
        assertTrue(f.processor.activeEntitlements().isEmpty())
        try { f.processor.checkLaunch(checkout); fail() } catch (_: AccountChanged) { }
    }
    @Test fun successfulRefreshRemovesRevokedRights() = runBlocking {
        val f = Fixture(); f.processor.refresh(); assertFalse(f.processor.activeEntitlements().isEmpty())
        f.backend.right = emptySet(); f.processor.refresh(); assertTrue(f.processor.activeEntitlements().isEmpty())
    }
    private fun assertCacheHiddenWhenSessionChanges(nextSession: BillingSession?) {
        val f = Fixture()
        val rights = setOf("caravan_skin")
        f.journal.cache["alice"] = rights
        f.journal.cache["bob"] = setOf("bob_skin")
        f.journal.onReadEntitlements = { f.sessions.value = nextSession }
        assertTrue(f.processor.activeEntitlements().isEmpty())
        assertEquals(rights, f.journal.cache["alice"])
        f.journal.onReadEntitlements = null
        assertEquals(
            nextSession?.let { f.journal.cache[it.uid].orEmpty() }.orEmpty(),
            f.processor.activeEntitlements(),
        )
    }
    @Test fun logoutDuringCacheReadHidesOldEntitlements() {
        assertCacheHiddenWhenSessionChanges(null)
    }
    @Test fun accountSwitchDuringCacheReadHidesOldEntitlements() {
        assertCacheHiddenWhenSessionChanges(BillingSession("bob", "login-2"))
    }
    @Test fun sameUidReloginDuringCacheReadHidesOldEntitlements() {
        assertCacheHiddenWhenSessionChanges(BillingSession("alice", "login-2"))
    }
    @Test fun deniedPendingPurchaseStillReconcilesRevokedCache() = runBlocking {
        val f = Fixture(); f.processor.prepare("skin"); f.processor.refresh()
        assertFalse(f.processor.activeEntitlements().isEmpty())
        f.backend.verificationFailure = PurchaseDenied(); f.backend.right = emptySet()
        try { f.processor.accept(f.event()); fail() } catch (_: PurchaseDenied) { }
        assertTrue(f.journal.queue.isEmpty()); assertTrue(f.processor.activeEntitlements().isEmpty())
    }
    @Test fun deniedResponseAfterAccountSwitchKeepsOriginalQueue() = runBlocking {
        val f = Fixture(); f.processor.prepare("skin")
        f.backend.verificationFailure = PurchaseDenied()
        f.backend.onVerify = { f.sessions.value = BillingSession("bob", "login-2") }
        try { f.processor.accept(f.event()); fail() } catch (_: AccountChanged) { }
        assertEquals(1, f.journal.pending("alice").size)
        assertTrue(f.journal.pending("bob").isEmpty())
        assertTrue(f.journal.cache.isEmpty())
        f.sessions.value = BillingSession("alice", "login-3")
        f.backend.onVerify = null
        f.backend.verificationFailure = null
        f.processor.refresh()
        assertTrue(f.journal.pending("alice").isEmpty())
        assertEquals(2, f.backend.calls)
        assertEquals(setOf("caravan_skin"), f.processor.activeEntitlements())
    }
    @Test fun deniedResponseAfterSameUidReloginKeepsOriginalQueue() = runBlocking {
        val f = Fixture(); f.processor.prepare("skin")
        f.backend.verificationFailure = PurchaseDenied()
        f.backend.onVerify = { f.sessions.value = BillingSession("alice", "login-2") }
        try { f.processor.accept(f.event()); fail() } catch (_: AccountChanged) { }
        assertEquals(1, f.journal.pending("alice").size)
        assertTrue(f.journal.cache.isEmpty())
    }
    @Test fun accountSessionsRejectTokenReturnedAfterLogout() = runBlocking {
        lateinit var sessions: AccountSessions
        sessions = AccountSessions { sessions.onAuthChanged(null); "stale-token" }
        sessions.onAuthChanged("alice"); val snapshot = sessions.current()!!
        try { sessions.idToken(snapshot); fail() } catch (_: AccountChanged) { }
    }

}
