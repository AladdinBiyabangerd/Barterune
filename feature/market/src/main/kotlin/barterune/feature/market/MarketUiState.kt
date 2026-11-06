package barterune.feature.market

import barterune.engine.command.RejectReason

/** Immutable screen state; all numbers come from the engine, all copy from resources. */
data class MarketUiState(
    val day: Int,
    val totalDays: Int,
    val gold: Long,
    val load: Int,
    val capacity: Int,
    val rows: List<GoodRow>,
    val detail: GoodDetail,
    val keypad: KeypadState? = null,
    val busy: Boolean = false,
    /** Compact (phone) master/detail destination; ignored by the two-column layout. */
    val section: CompactSection = CompactSection.LIST,
    val lastTrade: TradeOutcome? = null,
)

/** D6 V03 phone destinations, one D1-pixel-composition-v7 section each. */
enum class CompactSection { LIST, GOOD, BATCHES, QUANTITY, BUY_PREVIEW, SELL_PREVIEW, TRADE_SAVED }

/** Last committed trade, shown by the purchase-success / sale-success section. */
data class TradeOutcome(val bought: Boolean)

data class GoodRow(
    val goodId: String,
    val buyUnit: Long,
    val sellUnit: Long,
    val selected: Boolean,
    val stock: Int = 0,
    val owned: Int = 0,
    val unitLoad: Int = 0,
)

data class GoodDetail(
    val goodId: String,
    val buyUnit: Long,
    val sellUnit: Long,
    val stock: Int,
    val owned: Int,
    val unitLoad: Int,
    val sellBatch: BatchInfo?,
    val otherBatchUnits: Int,
    /** All batches of the good, highest quality first. */
    val batches: List<BatchInfo> = listOfNotNull(sellBatch),
    val quantity: Int,
    val buyMax: Int,
    val sellMax: Int,
    val buy: TradePreview,
    val sell: TradePreview,
)

data class BatchInfo(val batchId: String, val quantity: Int, val quality: Int, val averageCost: Long, val unitMargin: Long)

/** Conditional preview: never mutates state. [blockers] empty ⇒ action enabled. */
data class TradePreview(
    val total: Long,
    val goldFrom: Long,
    val goldTo: Long,
    val loadFrom: Int,
    val loadTo: Int,
    val blockers: List<RejectReason>,
) {
    val enabled: Boolean get() = blockers.isEmpty()
}

/**
 * D1-input-list-v18 keypad draft. Sign (−) and decimal point do not count toward the 6-digit cap.
 * Validation order: empty/sign-only → MINIMUM; dotted → WHOLE_NUMBERS; zero/negative int → MINIMUM;
 * more than 6 digits → DIGIT_CAP. Only a positive whole number applies; apply never buys/sells.
 */
data class KeypadState(val raw: String) {
    val digitCount: Int get() = raw.count { it.isDigit() }

    val value: Int? get() {
        if ('.' in raw) return null
        if (raw.isEmpty() || raw == SIGN) return null
        if (digitCount > 6) return null
        return normalize().toIntOrNull()?.takeIf { it >= 1 }
    }

    val valid: Boolean get() = value != null

    val problem: KeypadProblem? get() = when {
        valid -> null
        raw.isEmpty() || raw == SIGN -> KeypadProblem.MINIMUM
        '.' in raw -> KeypadProblem.WHOLE_NUMBERS
        normalize().toIntOrNull()?.let { it <= 0 } == true -> KeypadProblem.MINIMUM
        digitCount > 6 -> KeypadProblem.DIGIT_CAP
        else -> KeypadProblem.MINIMUM
    }

    private fun normalize(): String = raw.replace(SIGN, "-")

    companion object {
        const val SIGN = "−"
        const val DIGIT_SOFT_CAP = 12
    }
}

enum class KeypadProblem { MINIMUM, WHOLE_NUMBERS, DIGIT_CAP }
