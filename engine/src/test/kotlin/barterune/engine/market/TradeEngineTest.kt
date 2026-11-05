package barterune.engine.market

import barterune.content.ContentLoader
import barterune.engine.TradeEngine
import barterune.engine.command.BuyGoods
import barterune.engine.command.CommandResult
import barterune.engine.command.RejectReason
import barterune.engine.command.SellBatch
import barterune.engine.model.RunState
import barterune.engine.model.RunStateCodec
import barterune.engine.run.NewRunFactory
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class TradeEngineTest {
    private val content = ContentLoader.loadClassic()
    private val engine = TradeEngine(content)
    private val start = NewRunFactory(content).create(runId = "run-1", seed = 42L)

    private fun accepted(result: CommandResult): CommandResult.Accepted {
        assertTrue("expected Accepted but was $result", result is CommandResult.Accepted)
        return result as CommandResult.Accepted
    }

    @Test
    fun startFollowsB01AndDay1Stock() {
        assertEquals(300L, start.gold)
        assertEquals(30, start.capacity)
        assertEquals(60, start.market.good("grain")!!.stock) // producer 100%
        assertEquals(12, start.market.good("cloth")!!.stock) // high demand 50%
        assertEquals(15, start.market.good("iron")!!.stock) // neutral 75%, floor
    }

    @Test
    fun day1QuotesFollowB03() {
        val grain = start.market.good("grain")!!
        assertEquals(17L, engine.pricing.buyUnit("sunbulova", grain)) // ceil(15 × 1.10)
        assertEquals(13L, engine.pricing.sellUnit("sunbulova", grain, 100)) // floor(15 × 0.90)
        val cloth = start.market.good("cloth")!!
        assertEquals(83L, engine.pricing.buyUnit("sunbulova", cloth))
        assertEquals(67L, engine.pricing.sellUnit("sunbulova", cloth, 100))
        assertEquals(3L, engine.pricing.sellUnit("sunbulova", grain, 1)) // B07: quality floors at 25%
    }

    @Test
    fun buyCommandPaysGoldTakesStockAndCreatesBatch() {
        val result = accepted(engine.apply(start, BuyGoods("c1", 0, "grain", 3)))
        val s = result.state
        assertEquals(249L, s.gold)
        assertEquals(57, s.market.good("grain")!!.stock)
        assertEquals(6, engine.load(s))
        assertEquals(1L, s.revision)
        val batch = s.cargo.single()
        assertEquals("grain-q100", batch.batchId)
        assertEquals(3, batch.quantity)
        assertEquals(51L, batch.acquisitionCost)
        assertEquals(-51L, result.ledger.goldDelta)
        assertEquals(300L, start.gold) // input untouched
    }

    @Test
    fun sellCommandPaysQuotedPriceAndReducesBatch() {
        val bought = accepted(engine.apply(start, BuyGoods("c1", 0, "grain", 3))).state
        val result = accepted(engine.apply(bought, SellBatch("c2", 1, "grain-q100", 2)))
        val s = result.state
        assertEquals(275L, s.gold) // 249 + 2 × 13
        assertEquals(59, s.market.good("grain")!!.stock)
        assertEquals(1, s.cargo.single().quantity)
        assertEquals(17L, s.cargo.single().acquisitionCost) // 51 − 51×2/3
        assertEquals(2L, s.revision)
        assertEquals(1, s.market.good("grain")!!.netBoughtToday)
    }

    @Test
    fun sellingWholeBatchRemovesIt() {
        val bought = accepted(engine.apply(start, BuyGoods("c1", 0, "salt", 2))).state
        val s = accepted(engine.apply(bought, SellBatch("c2", 1, "salt-q100", 2))).state
        assertTrue(s.cargo.isEmpty())
    }

    @Test
    fun largeBuyRaisesLaterPriceOnlyAfterTrade() {
        val rich = start.copy(gold = 10_000, capacity = 1_000)
        val r = accepted(engine.apply(rich, BuyGoods("c1", 0, "grain", 15)))
        assertEquals(17L, r.ledger.unitPrice) // impact applies after the trade
        assertEquals(18L, engine.pricing.buyUnit("sunbulova", r.state.market.good("grain")!!)) // +5%
    }

    @Test
    fun buyRejectionListsEveryReason() {
        val result = engine.apply(start, BuyGoods("c1", 0, "cloth", 31))
        assertEquals(
            CommandResult.Rejected(listOf(RejectReason.OUT_OF_STOCK, RejectReason.NOT_ENOUGH_GOLD, RejectReason.NOT_ENOUGH_CAPACITY)),
            result,
        )
    }

    @Test
    fun staleRevisionAndInvalidQuantityAreRejected() {
        assertEquals(CommandResult.Rejected(listOf(RejectReason.STALE_REVISION)), engine.apply(start, BuyGoods("c1", 5, "grain", 1)))
        assertEquals(CommandResult.Rejected(listOf(RejectReason.INVALID_QUANTITY)), engine.apply(start, BuyGoods("c1", 0, "grain", 0)))
        assertEquals(CommandResult.Rejected(listOf(RejectReason.UNKNOWN_BATCH)), engine.apply(start, SellBatch("c1", 0, "grain-q100", 1)))
    }

    @Test
    fun sellOverflowStockIsCappedAtTwiceNormal() {
        val loaded = start.copy(
            capacity = 1_000,
            cargo = listOf(barterune.engine.model.CargoBatch("cloth-q100", "cloth", 100, 100, 0)),
        )
        val s = accepted(engine.apply(loaded, SellBatch("c1", 0, "cloth-q100", 100))).state
        assertEquals(48, s.market.good("cloth")!!.stock)
    }

    @Test
    fun limitsFollowDesignResolutions() {
        assertEquals(10, TradeLimits.buyMax(gold = 300, unitPrice = 17, freeLoad = 20, unitLoad = 2, stock = 60))
        assertEquals(TradeLimits.MAX_QUANTITY, TradeLimits.sellMax(5_000_000))
    }

    @Test
    fun snapshotRoundTripsExactly() {
        val s: RunState = accepted(engine.apply(start, BuyGoods("c1", 0, "wool", 4))).state
        assertEquals(s, RunStateCodec.decode(RunStateCodec.encode(s)))
    }
}
