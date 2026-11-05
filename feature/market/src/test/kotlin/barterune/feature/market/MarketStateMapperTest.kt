package barterune.feature.market

import barterune.content.ContentLoader
import barterune.engine.TradeEngine
import barterune.engine.command.BuyGoods
import barterune.engine.command.CommandResult
import barterune.engine.command.RejectReason
import barterune.engine.run.NewRunFactory
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class MarketStateMapperTest {
    private val content = ContentLoader.loadClassic()
    private val engine = TradeEngine(content)
    private val mapper = MarketStateMapper(content, engine)
    private val start = NewRunFactory(content).create("r", 1)

    @Test
    fun previewMatchesTheCommandItWouldIssue() {
        val ui = mapper.map(start, "grain", 3)
        assertEquals(51L, ui.detail.buy.total)
        assertEquals(249L, ui.detail.buy.goldTo)
        assertEquals(6, ui.detail.buy.loadTo)
        val after = (engine.apply(start, BuyGoods("c", 0, "grain", 3)) as CommandResult.Accepted).state
        assertEquals(ui.detail.buy.goldTo, after.gold)
        assertEquals(15, ui.detail.buyMax) // min(300/17=17, 30/2=15, stock 60)
    }

    @Test
    fun sellIsBlockedWithoutBatchAndBuyListsReasons() {
        val ui = mapper.map(start, "cloth", 31)
        assertNull(ui.detail.sellBatch)
        assertFalse(ui.detail.sell.enabled)
        assertEquals(listOf(RejectReason.OUT_OF_STOCK, RejectReason.NOT_ENOUGH_GOLD, RejectReason.NOT_ENOUGH_CAPACITY), ui.detail.buy.blockers)
    }

    @Test
    fun keypadAcceptsOnlyOneToSixDigits() {
        assertTrue(KeypadState("999999").valid)
        assertFalse(KeypadState("1234567").valid)
        assertFalse(KeypadState("").valid)
        assertFalse(KeypadState("0").valid)
    }
}
