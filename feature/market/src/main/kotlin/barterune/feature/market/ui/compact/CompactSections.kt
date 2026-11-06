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

/**
 * Compact rows. LIST has no rootBack (v17). GOOD/BATCHES/PREVIEW follow D1-trade-flow-v20:
 * preview and batches back to good detail; batch labels use D1-damaged-label-v19.
 */
@Composable
internal fun compactRows(state: MarketUiState, actions: MarketActions): List<CompactRow> {
    val rows = when (state.section) {
        CompactSection.LIST -> listRows(state, actions)
        CompactSection.GOOD -> goodRows(state, actions)
        CompactSection.BATCHES -> batchRows(state, actions)
        CompactSection.QUANTITY -> goodRows(state, actions)
        CompactSection.BUY_PREVIEW -> previewRows(state, actions, buy = true)
        CompactSection.SELL_PREVIEW -> previewRows(state, actions, buy = false)
        CompactSection.TRADE_SAVED -> savedRows(state, actions)
    }
    val back = when (state.section) {
        CompactSection.LIST -> null
        CompactSection.BUY_PREVIEW, CompactSection.SELL_PREVIEW, CompactSection.BATCHES ->
            CompactRow(stringResource(R.string.c_back_to_detail), Type.Label, onClick = actions.onBack)
        CompactSection.GOOD, CompactSection.QUANTITY, CompactSection.TRADE_SAVED ->
            CompactRow(stringResource(R.string.c_back_to_market), Type.Label, onClick = actions.onBackToMarket)
    }
    return if (back == null) rows else listOf(back) + rows
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

/** D1-trade-flow-v20 mal detalı: info → Miqdar → Partiyalar → Alış/Satış önbaxışı. */
@Composable
private fun goodRows(state: MarketUiState, actions: MarketActions): List<CompactRow> {
    val d = state.detail
    val batch = d.sellBatch
    val batchLabel = batch?.let { qualityLabel(it.quality) }
    return buildList {
        add(CompactRow(name(d.goodId), Type.ScreenTitle, icon = GoodArt.of(d.goodId)))
        add(CompactRow(stringResource(R.string.c_gold_load_short, state.gold, state.load, state.capacity), Type.Body))
        add(CompactRow(stringResource(R.string.c_buy_sell_prices, d.buyUnit, d.sellUnit), Type.Body))
        add(CompactRow(stringResource(R.string.c_quantity_change, d.quantity), Type.Label, onClick = actions.onQuantity))
        add(
            CompactRow(
                if (batchLabel != null) stringResource(R.string.c_batches_with_quality, batchLabel)
                else stringResource(R.string.c_batches),
                Type.Label,
                onClick = { actions.onNavigate(CompactSection.BATCHES) },
            ),
        )
        add(CompactRow(stringResource(R.string.c_buy_preview_go), Type.Label, onClick = { actions.onNavigate(CompactSection.BUY_PREVIEW) }))
        if (batch == null) {
            add(CompactRow(stringResource(R.string.c_no_sell_batch), Type.Body))
            add(CompactRow(stringResource(R.string.c_batches), Type.Label, onClick = { actions.onNavigate(CompactSection.BATCHES) }))
        } else {
            add(CompactRow(stringResource(R.string.c_sell_preview_go), Type.Label, onClick = { actions.onNavigate(CompactSection.SELL_PREVIEW) }))
        }
    }
}

/** D1-damaged-label-v19: `Zədəli · {q}%` / `Sağlam · 100%`; quantity is separate. */
@Composable
private fun qualityLabel(quality: Int): String =
    if (quality == 100) stringResource(R.string.c_healthy_quality, quality)
    else stringResource(R.string.c_damaged_quality, quality)

@Composable
private fun batchRows(state: MarketUiState, actions: MarketActions): List<CompactRow> = buildList {
    add(CompactRow(stringResource(R.string.c_batches), Type.SectionTitle))
    if (state.detail.batches.isEmpty()) add(CompactRow(stringResource(R.string.c_no_owned), Type.Label))
    state.detail.batches.forEach { b ->
        val selected = b.batchId == state.detail.sellBatch?.batchId
        val label = qualityLabel(b.quality)
        add(CompactRow(stringResource(if (selected) R.string.c_batch_selected else R.string.c_batch_unselected, label), Type.Label))
        add(CompactRow(stringResource(R.string.c_count_separate, b.quantity), Type.Body))
        add(CompactRow(stringResource(R.string.c_quality_affects_price), Type.Supporting))
        add(CompactRow(stringResource(R.string.c_cost_margin, b.averageCost, MarketText.signed(b.unitMargin)), Type.Body))
        if (!selected) add(CompactRow(stringResource(R.string.c_choose_batch, label), Type.Label, onClick = { actions.onSelectBatch(b.batchId) }))
    }
    add(CompactRow(stringResource(R.string.c_margin_note), Type.Supporting))
}

/** D1-trade-flow-v20 önbaxış: yalnız öz Al və ya Sat təsdiqi; limitdə səbəb + düzəliş yolları. */
@Composable
private fun previewRows(state: MarketUiState, actions: MarketActions, buy: Boolean): List<CompactRow> {
    val d = state.detail
    val p = if (buy) d.buy else d.sell
    val batch = d.sellBatch
    return buildList {
        add(CompactRow(stringResource(if (buy) R.string.c_buy_preview_title else R.string.c_sell_preview_title), Type.SectionTitle))
        add(CompactRow(stringResource(R.string.c_good_units, name(d.goodId), d.quantity), Type.Body, icon = GoodArt.of(d.goodId)))
        if (!buy) {
            if (batch == null) add(CompactRow(stringResource(R.string.c_no_owned), Type.Body))
            else add(CompactRow(stringResource(R.string.c_batch_in_stock, qualityLabel(batch.quality), batch.quantity), Type.Body))
        }
        if (p.enabled) {
            add(CompactRow(stringResource(R.string.c_total_gold, p.total), Type.Numeric))
            add(CompactRow(stringResource(R.string.c_gold_arrow, p.goldFrom, p.goldTo), Type.Numeric))
            add(CompactRow(stringResource(R.string.c_load_arrow, p.loadFrom, state.capacity, p.loadTo), Type.Numeric))
            add(
                CompactRow(
                    stringResource(if (buy) R.string.c_confirm_buy else R.string.c_confirm_sell, p.total),
                    Type.Label,
                    onClick = if (buy) actions.onBuy else actions.onSell,
                    enabled = !state.busy,
                ),
            )
        } else {
            val reason = p.blockers.firstOrNull()?.let { stringResource(MarketText.reason(it)) }
                ?: stringResource(R.string.c_trade_blocked)
            add(CompactRow(blockerMessage(buy, d, reason), Type.Body))
            add(CompactRow(stringResource(R.string.c_change_quantity), Type.Label, onClick = actions.onQuantity))
            if (!buy) {
                add(CompactRow(stringResource(R.string.c_change_batch), Type.Label, onClick = { actions.onNavigate(CompactSection.BATCHES) }))
                add(CompactRow(stringResource(R.string.c_sell_impossible), Type.Body))
            }
        }
    }
}

@Composable
private fun blockerMessage(buy: Boolean, d: barterune.feature.market.GoodDetail, reason: String): String {
    val batch = d.sellBatch
    return when {
        !buy && batch != null && d.quantity > batch.quantity ->
            stringResource(R.string.c_batch_only_count, batch.quantity)
        else -> reason
    }
}

@Composable
private fun savedRows(state: MarketUiState, actions: MarketActions): List<CompactRow> = listOf(
    CompactRow(stringResource(if (state.lastTrade?.bought != false) R.string.c_purchase_saved else R.string.c_sale_saved), Type.SectionTitle),
    CompactRow(stringResource(R.string.c_saved_gold_load, state.gold, state.load, state.capacity), Type.Numeric),
    CompactRow(stringResource(R.string.c_quantity_kept), Type.Body),
    CompactRow(stringResource(R.string.c_back_plain), Type.Label, onClick = actions.onBackToMarket),
)
