package barterune.feature.market

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import barterune.core.data.GameRepository
import barterune.engine.command.BuyGoods
import barterune.engine.command.GameCommand
import barterune.engine.command.SellBatch
import barterune.engine.model.RunState
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.util.UUID

/** Unidirectional state holder for the market. One tap ⇒ at most one committed command. */
class MarketViewModel(
    private val repository: GameRepository,
    private val mapper: MarketStateMapper,
    private val slotId: Int,
    private val newCommandId: () -> String = { UUID.randomUUID().toString() },
) : ViewModel() {
    private val _state = MutableStateFlow<MarketUiState?>(null)
    val state: StateFlow<MarketUiState?> = _state.asStateFlow()

    private var run: RunState? = null
    private var selectedGoodId = "grain"
    private var quantity = 1
    private var keypad: KeypadState? = null
    private var busy = false
    private var selectedBatchId: String? = null
    private var section = CompactSection.LIST
    private var keypadOrigin = CompactSection.GOOD
    private var lastTrade: TradeOutcome? = null

    init {
        viewModelScope.launch { run = repository.loadOrCreate(slotId); publish() }
    }

    fun selectGood(goodId: String) { selectedGoodId = goodId; selectedBatchId = null; publish() }

    /** Phone: list → good detail. */
    fun openGood(goodId: String) { selectGood(goodId); navigate(CompactSection.GOOD) }

    fun selectBatch(batchId: String) { selectedBatchId = batchId; publish() }

    fun navigate(target: CompactSection) {
        if (target != CompactSection.QUANTITY) keypad = null
        section = target
        publish()
    }

    /** "Bazara qayıt": keeps selection and committed quantity, drops an unapplied draft (navigation.json back). */
    fun backToMarket() { keypad = null; section = CompactSection.LIST; publish() }

    /** Max rows only change the quantity (designResolutions); 0 is never applied. */
    fun applyMax(max: Int) { if (max > 0) { quantity = max; publish() } }

    fun openKeypad() { keypadOrigin = section; keypad = KeypadState(quantity.toString()); section = CompactSection.QUANTITY; publish() }

    fun keypadDigit(digit: Char) {
        val k = keypad ?: return
        keypad = k.copy(raw = KeypadInput.appendDigit(k.raw, digit))
        publish()
    }

    fun keypadBackspace() {
        keypad = keypad?.let { it.copy(raw = KeypadInput.backspace(it.raw)) }
        publish()
    }

    fun keypadToggleSign() {
        val k = keypad ?: return
        keypad = k.copy(raw = KeypadInput.toggleSign(k.raw))
        publish()
    }

    fun keypadDecimal() {
        val k = keypad ?: return
        keypad = k.copy(raw = KeypadInput.appendDecimal(k.raw))
        publish()
    }

    /** Cancel/back restores the last applied quantity. */
    fun keypadCancel() { keypad = null; if (section == CompactSection.QUANTITY) section = keypadOrigin; publish() }

    /** Applies the quantity only; buying/selling stays a separate action. */
    fun keypadApply() {
        val value = keypad?.value ?: return
        quantity = value
        keypad = null
        if (section == CompactSection.QUANTITY) section = keypadOrigin
        publish()
    }

    /** Preview/batches back to good detail (D1-trade-flow-v20); good/saved back to list. */
    fun back() {
        when (section) {
            CompactSection.BUY_PREVIEW, CompactSection.SELL_PREVIEW, CompactSection.BATCHES, CompactSection.QUANTITY -> {
                keypad = null
                section = CompactSection.GOOD
            }
            else -> {
                keypad = null
                section = CompactSection.LIST
            }
        }
        publish()
    }

    fun buy() {
        val current = run ?: return
        execute(BuyGoods(newCommandId(), current.revision, selectedGoodId, quantity))
    }

    fun sell() {
        val current = run ?: return
        val batch = _state.value?.detail?.sellBatch ?: return
        execute(SellBatch(newCommandId(), current.revision, batch.batchId, quantity))
    }

    private fun execute(command: GameCommand) {
        if (busy) return
        busy = true
        publish()
        viewModelScope.launch {
            try {
                val result = repository.execute(slotId, command)
                run = repository.loadOrCreate(slotId)
                if (result is barterune.engine.command.CommandResult.Accepted) {
                    lastTrade = TradeOutcome(bought = command is BuyGoods)
                    if (section != CompactSection.LIST) section = CompactSection.TRADE_SAVED
                }
            } finally {
                busy = false
                publish()
            }
        }
    }

    private fun publish() {
        val current = run ?: return
        _state.value = mapper.map(current, selectedGoodId, quantity, selectedBatchId)
            .copy(keypad = keypad, busy = busy, section = section, lastTrade = lastTrade)
    }

}
