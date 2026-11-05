package barterune.engine.market

import barterune.content.CityRole
import barterune.content.ContentPack
import barterune.engine.model.MarketGoodState
import kotlin.math.abs
import kotlin.math.sign

/**
 * B03 prices with exact integer fractions; only the final unit price is rounded.
 * P = base × city ratio × daily fluctuation; buy = ceil(P × (1+impact) × 1.10),
 * sell = max(1, floor(P × (1+impact) × 0.90 × quality/100)).
 */
class MarketPricing(private val content: ContentPack) {

    fun buyUnit(cityId: String, market: MarketGoodState): Long {
        val (num, den) = basePriceFraction(cityId, market)
        return ceilDiv(Math.multiplyExact(num, content.pricing.buySpreadPercent.toLong()), den * PERCENT)
    }

    fun sellUnit(cityId: String, market: MarketGoodState, quality: Int): Long {
        val (num, den) = basePriceFraction(cityId, market)
        val n = Math.multiplyExact(Math.multiplyExact(num, content.pricing.sellSpreadPercent.toLong()), quality.toLong())
        return maxOf(1L, n / (den * PERCENT * PERCENT))
    }

    /** sign(x) × min(cap, step × floor(|x| / T)), T = max(1, ceil(normal/4)). */
    fun impactPercent(goodId: String, netBought: Int): Int {
        if (netBought == 0) return 0
        val normal = content.good(goodId).normalStock
        val tier = maxOf(1, (normal + 3) / 4)
        val magnitude = minOf(content.pricing.impactCapPercent, content.pricing.impactStepPercent * (abs(netBought) / tier))
        return netBought.sign * magnitude
    }

    private fun basePriceFraction(cityId: String, market: MarketGoodState): Pair<Long, Long> {
        val good = content.good(market.goodId)
        val ratio = when (content.city(cityId).roleOf(good.id)) {
            CityRole.PRODUCER -> content.pricing.producerPerMille
            CityRole.HIGH_DEMAND -> content.pricing.highDemandPerMille
            CityRole.NEUTRAL -> content.pricing.neutralPerMille
        }.toLong()
        val impact = 100L + impactPercent(good.id, market.netBoughtToday)
        val num = good.basePrice * ratio * market.fluctuationPercent * impact
        return num to PER_MILLE * PERCENT * PERCENT
    }

    private fun ceilDiv(a: Long, b: Long): Long = -Math.floorDiv(-a, b)

    private companion object {
        const val PERCENT = 100L
        const val PER_MILLE = 1000L
    }
}
