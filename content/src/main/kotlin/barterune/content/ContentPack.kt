package barterune.content

import kotlinx.serialization.Serializable

/** Versioned, immutable game content. A started run pins [contentVersion]. */
@Serializable
data class ContentPack(
    val contentVersion: String,
    val rulesetVersion: String,
    val start: StartRules,
    val pricing: PricingRules,
    val goods: List<GoodDef>,
    val cities: List<CityDef>,
) {
    fun good(id: String): GoodDef = goods.first { it.id == id }
    fun city(id: String): CityDef = cities.first { it.id == id }
}

/** B01 start conditions. */
@Serializable
data class StartRules(val gold: Long, val capacity: Int, val cityId: String, val totalDays: Int)

/** B02/B03 numbers. Ratios are integer per-mille / percent to avoid floating point money. */
@Serializable
data class PricingRules(
    val producerPerMille: Int,
    val highDemandPerMille: Int,
    val neutralPerMille: Int,
    val buySpreadPercent: Int,
    val sellSpreadPercent: Int,
    val impactStepPercent: Int,
    val impactCapPercent: Int,
    val stockCapMultiplier: Int,
    val day1StockPercent: Map<CityRole, Int>,
)

/** B02: base price / unit load / normal stock / daily restock. */
@Serializable
data class GoodDef(
    val id: String,
    val basePrice: Long,
    val unitLoad: Int,
    val normalStock: Int,
    val dailyRestock: Int,
)

@Serializable
data class CityDef(val id: String, val produces: List<String>, val highDemand: List<String>) {
    fun roleOf(goodId: String): CityRole = when (goodId) {
        in produces -> CityRole.PRODUCER
        in highDemand -> CityRole.HIGH_DEMAND
        else -> CityRole.NEUTRAL
    }
}

@Serializable
enum class CityRole { PRODUCER, HIGH_DEMAND, NEUTRAL }
