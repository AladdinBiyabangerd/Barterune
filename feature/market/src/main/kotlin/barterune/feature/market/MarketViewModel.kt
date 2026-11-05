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

    init {
        viewModelScope.launch { run = repository.loadOrCreate(slotId); publish() }
    }

    fun selectGood(goodId: String) { selectedGoodId = goodId; publish() }

    fun openKeypad() { keypad = KeypadState(quantity.toString()); publish() }

    fun keypadDigit(digit: Char) {
        val k = keypad ?: return
        if (k.raw.length < KEYPAD_MAX_CHARS) keypad = k.copy(raw = k.raw + digit)
        publish()
    }

    fun keypadBackspace() { keypad = keypad?.let { it.copy(raw = it.raw.dropLast(1)) }; publish() }

    /** Cancel/back restores the last applied quantity. */
    fun keypadCancel() { keypad = null; publish() }

    /** Applies the quantity only; buying/selling stays a separate action. */
    fun keypadApply() {
        val value = keypad?.value ?: return
        quantity = value
        keypad = null
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
                repository.execute(slotId, command)
                run = repository.loadOrCreate(slotId)
            } finally {
                busy = false
                publish()
            }
        }
    }

    private fun publish() {
        val current = run ?: return
        _state.value = mapper.map(current, selectedGoodId, quantity).copy(keypad = keypad, busy = busy)
    }

    private companion object { const val KEYPAD_MAX_CHARS = 7 }
}
