package barterune.feature.market.ui.compact

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import barterune.core.designsystem.component.GoodArt
import barterune.core.designsystem.token.BarteruneTypography as Type
import barterune.feature.market.CompactSection
import barterune.feature.market.MarketActions
import barterune.feature.market.MarketUiState
import barterune.feature.market.ui.MarketText
import com.aladdin.barterune.feature.market.R

/** Rows of one v7 section. D1-review-v17 interaction.json: detail sections start with the back row; the LIST root has none. */
@Composable
internal fun compactRows(state: MarketUiState, actions: MarketActions): List<CompactRow> {
    val back = CompactRow(stringResource(R.string.c_back_to_market), Type.Label, onClick = actions.onBackToMarket)
    val rows = when (state.section) {
        CompactSection.LIST -> listRows(state, actions)
        CompactSection.GOOD -> goodRows(state, actions)
        CompactSection.BATCHES -> batchRows(state, actions)
        // Quantity uses the fixed D1-keypad-fixed-v16 screen.
        CompactSection.QUANTITY -> goodRows(state, actions)
        CompactSection.BUY_PREVIEW -> previewRows(state, actions, buy = true)
        CompactSection.SELL_PREVIEW -> previewRows(state, actions, buy = false)
        CompactSection.TRADE_SAVED -> savedRows(state, actions)
    }
    return if (state.section == CompactSection.LIST) rows else listOf(back) + rows
}

@Composable
private fun name(goodId: String) = stringResource(MarketText.goodName(goodId))

@Composable
private fun listRows(state: MarketUiState, actions: MarketActions): List<CompactRow> = buildList {
    add(CompactRow(stringResource(R.string.c_goods_list), Type.SectionTitle))
    state.rows.forEach { row ->
        val n = name(row.goodId)
        val owned = if (row.selected) state.detail.owned else ownedOf(state, row.goodId)
        add(CompactRow(if (row.selected) stringResource(R.string.c_good_selected, n) else n, Type.SectionTitle, icon = GoodArt.of(row.goodId)))
        add(CompactRow(stringResource(R.string.c_buy_sell, row.buyUnit, row.sellUnit), Type.Numeric))
        add(CompactRow(stringResource(R.string.c_stock_owned_load, row.stock, owned, row.unitLoad), Type.Body))
        add(CompactRow(stringResource(R.string.c_open_details, n), Type.Label, onClick = { actions.onOpenGood(row.goodId) }))
    }
}

private fun ownedOf(state: MarketUiState, goodId: String): Int = state.rows.first { it.goodId == goodId }.owned

@Composable
private fun goodRows(state: MarketUiState, actions: MarketActions): List<CompactRow> {
    val d = state.detail
    return listOf(
        CompactRow(name(d.goodId), Type.ScreenTitle, icon = GoodArt.of(d.goodId)),
        CompactRow(stringResource(R.string.c_unit_prices, d.buyUnit, d.sellUnit), Type.Body),
        CompactRow(stringResource(R.string.c_stock_owned_load, d.stock, d.owned, d.unitLoad), Type.Body),
        CompactRow(stringResource(R.string.c_batches), Type.Label, onClick = { actions.onNavigate(CompactSection.BATCHES) }),
        CompactRow(stringResource(R.string.c_quantity, d.quantity), Type.Label, onClick = actions.onQuantity),
    )
}

@Composable
private fun batchName(quality: Int) = stringResource(if (quality == 100) R.string.c_healthy else R.string.c_damaged)

@Composable
private fun batchRows(state: MarketUiState, actions: MarketActions): List<CompactRow> = buildList {
    add(CompactRow(stringResource(R.string.c_batches), Type.SectionTitle))
    if (state.detail.batches.isEmpty()) add(CompactRow(stringResource(R.string.c_no_owned), Type.Label))
    state.detail.batches.forEach { b ->
        val selected = b.batchId == state.detail.sellBatch?.batchId
        val bn = batchName(b.quality)
        add(CompactRow(stringResource(if (selected) R.string.c_batch_selected else R.string.c_batch_unselected, bn), Type.Label))
        add(CompactRow(stringResource(R.string.c_quality_count, b.quality, b.quantity), Type.Body))
        add(CompactRow(if (b.quality < 100) stringResource(R.string.c_cost_no_sell, b.averageCost) else stringResource(R.string.c_cost_margin, b.averageCost, MarketText.signed(b.unitMargin)), Type.Body))
        if (!selected) add(CompactRow(stringResource(R.string.c_choose_batch, bn), Type.Label, onClick = { actions.onSelectBatch(b.batchId) }))
    }
    add(CompactRow(stringResource(R.string.c_margin_note), Type.Supporting))
}

@Composable
private fun previewRows(state: MarketUiState, actions: MarketActions, buy: Boolean): List<CompactRow> {
    val d = state.detail
    val p = if (buy) d.buy else d.sell
    val batch = d.sellBatch
    return listOf(
        CompactRow(stringResource(if (buy) R.string.c_buy_preview else R.string.c_sell_preview), Type.SectionTitle),
        CompactRow(stringResource(R.string.c_good_quantity, name(d.goodId), d.quantity), Type.Body, icon = GoodArt.of(d.goodId)),
        if (batch == null) CompactRow(stringResource(R.string.c_no_owned), Type.Body)
        else CompactRow(stringResource(R.string.c_batch_count, batchName(batch.quality), batch.quantity), Type.Body),
        CompactRow(stringResource(if (buy) R.string.c_buy_total else R.string.c_sell_total, p.total), Type.Numeric),
        CompactRow(stringResource(R.string.c_gold_load, p.goldFrom, p.goldTo, p.loadFrom, state.capacity, p.loadTo), Type.Numeric),
        CompactRow(stringResource(R.string.c_buy_max, d.buyMax), Type.Label, onClick = { actions.onApplyMax(d.buyMax) }, enabled = d.buyMax > 0),
        CompactRow(stringResource(R.string.c_sell_max, d.sellMax), Type.Label, onClick = { actions.onApplyMax(d.sellMax) }, enabled = d.sellMax > 0),
        CompactRow(stringResource(R.string.c_max_note), Type.Supporting),
        CompactRow(
            buyLabel(state), Type.Label, onClick = actions.onBuy, enabled = d.buy.enabled && !state.busy,
            pair = CompactRow(sellLabel(state), Type.Label, onClick = actions.onSell, enabled = d.sell.enabled && !state.busy),
        ),
    )
}

@Composable
private fun buyLabel(state: MarketUiState): String {
    val b = state.detail.buy
    return when (b.blockers.size) {
        0 -> stringResource(R.string.market_buy, b.total)
        1 -> stringResource(R.string.market_buy_blocked, b.total, stringResource(MarketText.reason(b.blockers.single())))
        else -> stringResource(R.string.market_buy_many, b.blockers.size)
    }
}

@Composable
private fun sellLabel(state: MarketUiState): String {
    val s = state.detail.sell
    return if (s.enabled) stringResource(R.string.market_sell, s.total)
    else stringResource(R.string.market_sell_blocked, stringResource(MarketText.reason(s.blockers.first())))
}

@Composable
private fun savedRows(state: MarketUiState, actions: MarketActions): List<CompactRow> = listOf(
    CompactRow(stringResource(if (state.lastTrade?.bought != false) R.string.c_purchase_saved else R.string.c_sale_saved), Type.SectionTitle),
    CompactRow(stringResource(R.string.c_saved_gold_load, state.gold, state.load, state.capacity), Type.Numeric),
    CompactRow(stringResource(R.string.c_quantity_kept), Type.Body),
    CompactRow(stringResource(R.string.c_back_plain), Type.Label, onClick = actions.onBackToMarket),
)
