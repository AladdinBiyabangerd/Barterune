package barterune.feature.market

import barterune.content.ContentLoader
import barterune.core.data.GameRepository
import barterune.engine.TradeEngine
import barterune.engine.command.CommandResult
import barterune.engine.command.GameCommand
import barterune.engine.model.RunState
import barterune.engine.run.NewRunFactory
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.resetMain
import kotlinx.coroutines.test.setMain
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Before
import org.junit.Test

@OptIn(ExperimentalCoroutinesApi::class)
class MarketNavigationTest {
    private val content = ContentLoader.loadClassic()
    private val engine = TradeEngine(content)

    private class FakeRepository(private val engine: TradeEngine, start: RunState) : GameRepository {
        val state = MutableStateFlow(start)
        override suspend fun loadOrCreate(slotId: Int) = state.value
        override fun observe(slotId: Int): Flow<RunState?> = state
        override suspend fun execute(slotId: Int, command: GameCommand): CommandResult =
            engine.apply(state.value, command).also { if (it is CommandResult.Accepted) state.value = it.state }
    }

    @Before fun setUp() = Dispatchers.setMain(UnconfinedTestDispatcher())
    @After fun tearDown() = Dispatchers.resetMain()

    private fun viewModel() = MarketViewModel(FakeRepository(engine, NewRunFactory(content).create("r", 1)), MarketStateMapper(content, engine), 1)

    @Test
    fun phoneFlowListGoodQuantityPreviewBuySaved() {
        val vm = viewModel()
        vm.openGood("salt")
        assertEquals(CompactSection.GOOD, vm.state.value!!.section)
        vm.openKeypad(); vm.keypadBackspace(); vm.keypadDigit('3')
        assertEquals(CompactSection.QUANTITY, vm.state.value!!.section)
        vm.keypadApply()
        assertEquals(CompactSection.BUY_PREVIEW, vm.state.value!!.section)
        assertEquals(3, vm.state.value!!.detail.quantity)
        vm.buy()
        val s = vm.state.value!!
        assertEquals(CompactSection.TRADE_SAVED, s.section)
        assertEquals(TradeOutcome(bought = true), s.lastTrade)
        vm.backToMarket()
        assertEquals(CompactSection.LIST, vm.state.value!!.section)
        assertEquals("salt", vm.state.value!!.detail.goodId) // selection preserved
    }

    @Test
    fun cancelDiscardsDraftAndKeepsCommittedQuantity() {
        val vm = viewModel()
        vm.openGood("grain"); vm.openKeypad(); vm.keypadDigit('9'); vm.keypadCancel()
        assertNull(vm.state.value!!.keypad)
        assertEquals(1, vm.state.value!!.detail.quantity)
        assertEquals(CompactSection.GOOD, vm.state.value!!.section)
    }

    @Test
    fun maxRowsOnlyChangeQuantity() {
        val vm = viewModel()
        vm.openGood("grain")
        val max = vm.state.value!!.detail.buyMax
        vm.applyMax(max)
        assertEquals(max, vm.state.value!!.detail.quantity)
        assertEquals(300L, vm.state.value!!.gold)
        vm.applyMax(0)
        assertEquals(max, vm.state.value!!.detail.quantity)
    }
}
