package barterune.engine.run

import barterune.content.ContentPack
import barterune.engine.model.MarketGoodState
import barterune.engine.model.MarketState
import barterune.engine.model.RunState

/** B01/B02 start: fixed gold, capacity and city; day-1 stock by city role, rounded down. */
class NewRunFactory(private val content: ContentPack) {
    fun create(runId: String, seed: Long): RunState {
        val city = content.city(content.start.cityId)
        val goods = content.goods.map { good ->
            val percent = content.pricing.day1StockPercent.getValue(city.roleOf(good.id))
            MarketGoodState(goodId = good.id, stock = good.normalStock * percent / 100)
        }
        return RunState(
            runId = runId,
            lineageId = runId,
            seed = seed,
            rulesetVersion = content.rulesetVersion,
            contentVersion = content.contentVersion,
            day = 1,
            totalDays = content.start.totalDays,
            cityId = city.id,
            gold = content.start.gold,
            capacity = content.start.capacity,
            revision = 0,
            cargo = emptyList(),
            market = MarketState(city.id, 1, goods),
        )
    }
}
