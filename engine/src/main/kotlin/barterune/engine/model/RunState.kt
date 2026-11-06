package barterune.engine.model

import kotlinx.serialization.Serializable

/** Whole-run snapshot. Money is integer [Long]; [revision] increases once per accepted command. */
@Serializable
data class RunState(
    val runId: String,
    val lineageId: String,
    val seed: Long,
    val rulesetVersion: String,
    val contentVersion: String,
    val day: Int,
    val totalDays: Int,
    val cityId: String,
    val gold: Long,
    val capacity: Int,
    val revision: Long,
    val cargo: List<CargoBatch>,
    val market: MarketState,
    val rewindUsed: Boolean = false,
)

/** One quality batch of a good. [acquisitionCost] is the total paid for the remaining units. */
@Serializable
data class CargoBatch(
    val batchId: String,
    val goodId: String,
    val quantity: Int,
    val quality: Int,
    val acquisitionCost: Long,
) {
    /** Average unit cost, rounded down for display. */
    val averageCost: Long get() = if (quantity == 0) 0 else acquisitionCost / quantity
}

@Serializable
data class MarketState(val cityId: String, val day: Int, val goods: List<MarketGoodState>) {
    fun good(goodId: String): MarketGoodState? = goods.firstOrNull { it.goodId == goodId }
}

/** [netBoughtToday] = player bought − sold today (B03 market impact counter). */
@Serializable
data class MarketGoodState(
    val goodId: String,
    val stock: Int,
    val netBoughtToday: Int = 0,
    val fluctuationPercent: Int = 100,
)
