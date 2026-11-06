package barterune.feature.market

import barterune.content.ContentPack
import barterune.engine.TradeEngine
import barterune.engine.command.RejectReason
import barterune.engine.market.TradeLimits
import barterune.engine.model.RunState

/** Builds [MarketUiState] from a run snapshot. Previews use the same rules as the engine commands. */
class MarketStateMapper(private val content: ContentPack, private val engine: TradeEngine) {

    fun map(state: RunState, selectedGoodId: String, quantity: Int, selectedBatchId: String? = null): MarketUiState {
        val load = engine.load(state)
        val rows = content.goods.map { good ->
            val market = state.market.good(good.id)!!
            GoodRow(
                goodId = good.id,
                buyUnit = engine.pricing.buyUnit(state.cityId, market),
                sellUnit = engine.pricing.sellUnit(state.cityId, market, TradeEngine.FRESH_QUALITY),
                selected = good.id == selectedGoodId,
                stock = market.stock,
                owned = state.cargo.filter { it.goodId == good.id }.sumOf { it.quantity },
                unitLoad = good.unitLoad,
            )
        }
        return MarketUiState(
            day = state.day,
            totalDays = state.totalDays,
            gold = state.gold,
            load = load,
            capacity = state.capacity,
            rows = rows,
            detail = detail(state, selectedGoodId, quantity, load, selectedBatchId),
        )
    }

    private fun detail(state: RunState, goodId: String, quantity: Int, load: Int, selectedBatchId: String?): GoodDetail {
        val good = content.good(goodId)
        val market = state.market.good(goodId)!!
        val buyUnit = engine.pricing.buyUnit(state.cityId, market)
        val batches = state.cargo.filter { it.goodId == goodId }.sortedByDescending { it.quality }
        val selected = batches.firstOrNull { it.batchId == selectedBatchId } ?: batches.firstOrNull()
        val sellUnit = engine.pricing.sellUnit(state.cityId, market, selected?.quality ?: TradeEngine.FRESH_QUALITY)
        val buyTotal = buyUnit * quantity
        val buyLoad = quantity * good.unitLoad
        val buyBlockers = buildList {
            if (quantity > market.stock) add(RejectReason.OUT_OF_STOCK)
            if (buyTotal > state.gold) add(RejectReason.NOT_ENOUGH_GOLD)
            if (load + buyLoad > state.capacity) add(RejectReason.NOT_ENOUGH_CAPACITY)
        }
        val sellTotal = sellUnit * quantity
        val sellBlockers = when {
            selected == null -> listOf(RejectReason.UNKNOWN_BATCH)
            quantity > selected.quantity -> listOf(RejectReason.NOT_ENOUGH_IN_BATCH)
            else -> emptyList()
        }
        return GoodDetail(
            goodId = goodId,
            buyUnit = buyUnit,
            sellUnit = sellUnit,
            stock = market.stock,
            owned = batches.sumOf { it.quantity },
            unitLoad = good.unitLoad,
            sellBatch = selected?.let { BatchInfo(it.batchId, it.quantity, it.quality, it.averageCost, sellUnit - it.averageCost) },
            otherBatchUnits = batches.filter { it != selected }.sumOf { it.quantity },
            batches = batches.map {
                val unit = engine.pricing.sellUnit(state.cityId, market, it.quality)
                BatchInfo(it.batchId, it.quantity, it.quality, it.averageCost, unit - it.averageCost)
            },
            quantity = quantity,
            buyMax = TradeLimits.buyMax(state.gold, buyUnit, state.capacity - load, good.unitLoad, market.stock),
            sellMax = TradeLimits.sellMax(selected?.quantity ?: 0),
            buy = TradePreview(buyTotal, state.gold, state.gold - buyTotal, load, load + buyLoad, buyBlockers),
            sell = TradePreview(
                sellTotal, state.gold, state.gold + sellTotal, load,
                load - (if (selected == null) 0 else quantity * good.unitLoad), sellBlockers,
            ),
        )
    }
}
