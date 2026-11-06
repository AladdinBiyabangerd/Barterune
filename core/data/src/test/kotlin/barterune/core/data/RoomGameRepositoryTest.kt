package barterune.core.data

import android.content.Context
import androidx.test.core.app.ApplicationProvider
import barterune.content.ContentLoader
import barterune.core.database.BarteruneDatabase
import barterune.engine.TradeEngine
import barterune.engine.command.BuyGoods
import barterune.engine.command.CommandResult
import barterune.engine.command.SellBatch
import barterune.engine.run.NewRunFactory
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [35])
class RoomGameRepositoryTest {
    private val context = ApplicationProvider.getApplicationContext<Context>()
    private val content = ContentLoader.loadClassic()

    private fun openRepository(db: BarteruneDatabase) =
        RoomGameRepository(db, TradeEngine(content), NewRunFactory(content), newRunId = { "run-test" }, newSeed = { 7L })

    @Test
    fun stateIsIdenticalAfterProcessRestart() = runTest {
        context.deleteDatabase("restart.db")
        val first = BarteruneDatabase.build(context, "restart.db")
        val repo = openRepository(first)
        val start = repo.loadOrCreate(slotId = 1)
        val afterBuy = (repo.execute(1, BuyGoods("cmd-1", start.revision, "grain", 4)) as CommandResult.Accepted).state
        val afterSell = (repo.execute(1, SellBatch("cmd-2", afterBuy.revision, "grain-q100", 1)) as CommandResult.Accepted).state
        first.close() // simulated process death: new database instance, new repository

        val second = BarteruneDatabase.build(context, "restart.db")
        val reopened = openRepository(second).loadOrCreate(slotId = 1)
        assertEquals(afterSell, reopened)
        assertEquals(2L, reopened.revision)
        second.close()
    }

    @Test
    fun duplicateCommandIdIsNotAppliedTwice() = runTest {
        context.deleteDatabase("dup.db")
        val db = BarteruneDatabase.build(context, "dup.db")
        val repo = openRepository(db)
        val start = repo.loadOrCreate(1)
        val first = repo.execute(1, BuyGoods("same", start.revision, "salt", 2))
        assertTrue(first is CommandResult.Accepted)
        val again = repo.execute(1, BuyGoods("same", 1, "salt", 2))
        assertTrue(again is CommandResult.Rejected)
        assertEquals(1L, repo.loadOrCreate(1).revision)
        db.close()
    }
}
