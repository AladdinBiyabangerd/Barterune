package barterune.engine.market

import barterune.content.ContentLoader
import barterune.engine.TradeEngine
import barterune.engine.run.NewRunFactory
import org.junit.Assert.assertEquals
import org.junit.Test

/** B03/B07: quality sell unit = floor(P × (1+impact) × 0.90 × quality/100), min 1, quality floor 25%. */
class QualitySellPriceTest {
    private val content = ContentLoader.loadClassic()
    private val engine = TradeEngine(content)
    private val start = NewRunFactory(content).create(runId = "run-1", seed = 42L)
    private val grain = start.market.good("grain")!! // Sünbülova day 1: P = 15

    @Test
    fun scalesWithQualityAndFloors() {
        assertEquals(13L, engine.pricing.sellUnit("sunbulova", grain, 100)) // floor(13.5)
        assertEquals(8L, engine.pricing.sellUnit("sunbulova", grain, 60)) // floor(8.1)
        assertEquals(10L, engine.pricing.sellUnit("sunbulova", grain, 80)) // floor(10.8)
    }

    @Test
    fun qualityBelowMinimumIsPricedAt25() {
        assertEquals(3L, engine.pricing.sellUnit("sunbulova", grain, 25)) // floor(3.375)
        assertEquals(3L, engine.pricing.sellUnit("sunbulova", grain, 10))
        assertEquals(3L, engine.pricing.sellUnit("sunbulova", grain, 0))
    }

    @Test
    fun neverAboveFullQuality() {
        assertEquals(13L, engine.pricing.sellUnit("sunbulova", grain, 150))
    }
}
