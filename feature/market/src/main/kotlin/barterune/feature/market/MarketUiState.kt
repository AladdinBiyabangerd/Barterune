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
)

data class GoodRow(val goodId: String, val buyUnit: Long, val sellUnit: Long, val selected: Boolean)

data class GoodDetail(
    val goodId: String,
    val buyUnit: Long,
    val sellUnit: Long,
    val stock: Int,
    val owned: Int,
    val unitLoad: Int,
    val sellBatch: BatchInfo?,
    val otherBatchUnits: Int,
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

data class KeypadState(val raw: String) {
    val value: Int? get() = raw.takeIf { it.length in 1..6 }?.toIntOrNull()?.takeIf { it >= 1 }
    val valid: Boolean get() = value != null
}
