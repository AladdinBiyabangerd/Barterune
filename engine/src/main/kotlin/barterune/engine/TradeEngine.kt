package barterune.engine

import barterune.content.ContentPack
import barterune.engine.command.BuyGoods
import barterune.engine.command.CommandResult
import barterune.engine.command.GameCommand
import barterune.engine.command.LedgerDelta
import barterune.engine.command.RejectReason
import barterune.engine.command.SellBatch
import barterune.engine.market.MarketPricing
import barterune.engine.market.TradeLimits
import barterune.engine.model.CargoBatch
import barterune.engine.model.RunState

/** Applies market commands. Pure: never mutates its input, validates everything at execution time. */
class TradeEngine(private val content: ContentPack) {
    val pricing = MarketPricing(content)

    fun load(state: RunState): Int = state.cargo.sumOf { it.quantity * content.good(it.goodId).unitLoad }

    fun apply(state: RunState, command: GameCommand): CommandResult {
        if (command.expectedRevision != state.revision) return CommandResult.Rejected(listOf(RejectReason.STALE_REVISION))
        return when (command) {
            is BuyGoods -> buy(state, command)
            is SellBatch -> sell(state, command)
        }
    }

    private fun buy(state: RunState, cmd: BuyGoods): CommandResult {
        val market = state.market.good(cmd.goodId) ?: return reject(RejectReason.UNKNOWN_GOOD)
        if (cmd.quantity !in 1..TradeLimits.MAX_QUANTITY) return reject(RejectReason.INVALID_QUANTITY)
        val good = content.good(cmd.goodId)
        val unit = pricing.buyUnit(state.cityId, market)
        val total = runCatching { Math.multiplyExact(unit, cmd.quantity.toLong()) }.getOrNull()
            ?: return reject(RejectReason.AMOUNT_OVERFLOW)
        val loadDelta = cmd.quantity * good.unitLoad
        val reasons = buildList {
            if (cmd.quantity > market.stock) add(RejectReason.OUT_OF_STOCK)
            if (total > state.gold) add(RejectReason.NOT_ENOUGH_GOLD)
            if (load(state) + loadDelta > state.capacity) add(RejectReason.NOT_ENOUGH_CAPACITY)
        }
        if (reasons.isNotEmpty()) return CommandResult.Rejected(reasons)

        val batchId = batchId(cmd.goodId, FRESH_QUALITY)
        val existing = state.cargo.firstOrNull { it.batchId == batchId }
        val merged = existing?.copy(quantity = existing.quantity + cmd.quantity, acquisitionCost = existing.acquisitionCost + total)
            ?: CargoBatch(batchId, cmd.goodId, cmd.quantity, FRESH_QUALITY, total)
        val cargo = if (existing == null) state.cargo + merged else state.cargo.map { if (it.batchId == batchId) merged else it }
        val next = state.copy(
            gold = state.gold - total,
            cargo = cargo,
            market = state.market.copy(goods = state.market.goods.map {
                if (it.goodId == cmd.goodId) it.copy(stock = it.stock - cmd.quantity, netBoughtToday = it.netBoughtToday + cmd.quantity) else it
            }),
            revision = state.revision + 1,
        )
        return CommandResult.Accepted(next, LedgerDelta(cmd.goodId, cmd.quantity, unit, -total, loadDelta))
    }

    private fun sell(state: RunState, cmd: SellBatch): CommandResult {
        val batch = state.cargo.firstOrNull { it.batchId == cmd.batchId } ?: return reject(RejectReason.UNKNOWN_BATCH)
        if (cmd.quantity !in 1..TradeLimits.MAX_QUANTITY) return reject(RejectReason.INVALID_QUANTITY)
        if (cmd.quantity > batch.quantity) return reject(RejectReason.NOT_ENOUGH_IN_BATCH)
        val market = state.market.good(batch.goodId) ?: return reject(RejectReason.UNKNOWN_GOOD)
        val good = content.good(batch.goodId)
        val unit = pricing.sellUnit(state.cityId, market, batch.quality)
        val total = runCatching { Math.multiplyExact(unit, cmd.quantity.toLong()) }.getOrNull()
            ?: return reject(RejectReason.AMOUNT_OVERFLOW)
        val remaining = batch.quantity - cmd.quantity
        val costLeft = if (remaining == 0) 0 else batch.acquisitionCost - batch.acquisitionCost * cmd.quantity / batch.quantity
        val cargo = if (remaining == 0) state.cargo.filterNot { it.batchId == batch.batchId }
        else state.cargo.map { if (it.batchId == batch.batchId) it.copy(quantity = remaining, acquisitionCost = costLeft) else it }
        // B02: stock rises on sale up to 2× normal; overflow is not returned to the player.
        val stockCap = good.normalStock * content.pricing.stockCapMultiplier
        val next = state.copy(
            gold = state.gold + total,
            cargo = cargo,
            market = state.market.copy(goods = state.market.goods.map {
                if (it.goodId == batch.goodId) it.copy(stock = minOf(stockCap, it.stock + cmd.quantity), netBoughtToday = it.netBoughtToday - cmd.quantity) else it
            }),
            revision = state.revision + 1,
        )
        return CommandResult.Accepted(next, LedgerDelta(batch.goodId, cmd.quantity, unit, total, -cmd.quantity * good.unitLoad))
    }

    private fun reject(reason: RejectReason) = CommandResult.Rejected(listOf(reason))

    companion object {
        const val FRESH_QUALITY = 100
        fun batchId(goodId: String, quality: Int) = "$goodId-q$quality"
    }
}
