package barterune.feature.market.ui

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.BasicText
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import barterune.core.designsystem.component.GameButton
import barterune.core.designsystem.token.BarteruneColors
import barterune.core.designsystem.token.BarteruneSpacing
import barterune.core.designsystem.token.BarteruneTypography
import barterune.feature.market.GoodDetail
import barterune.feature.market.TradePreview
import com.aladdin.barterune.feature.market.R

/** Right detail (P3): good, sell batch, quantity, buy/sell previews, side-by-side Al/Sat. */
@Composable
internal fun GoodDetailPanel(
    detail: GoodDetail,
    busy: Boolean,
    onQuantity: () -> Unit,
    onBuy: () -> Unit,
    onSell: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(modifier.fillMaxSize()) {
        Column(
            Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState())
                .padding(start = BarteruneSpacing.Inset, top = BarteruneSpacing.Inset, end = BarteruneSpacing.Inset),
        ) {
            val name = stringResource(MarketText.goodName(detail.goodId))
            Section(
                stringResource(R.string.market_selected_prefix, name),
                stringResource(R.string.market_detail_prices, detail.buyUnit, detail.sellUnit, detail.stock, detail.owned, detail.unitLoad),
            )
            val batch = detail.sellBatch
            if (batch == null) {
                Section(stringResource(R.string.market_batches_title), stringResource(R.string.market_batches_empty))
            } else {
                val title = if (batch.quality == 100) stringResource(R.string.market_batch_healthy_title)
                else stringResource(R.string.market_batch_title, batch.quality)
                val body = stringResource(R.string.market_batch_body, batch.quantity, batch.quality, batch.averageCost, MarketText.signed(batch.unitMargin))
                Section(
                    stringResource(R.string.market_selected_prefix, title),
                    if (detail.otherBatchUnits > 0) stringResource(R.string.market_batch_other, body, detail.otherBatchUnits) else body,
                )
            }
            Section(
                stringResource(R.string.market_quantity_title, detail.quantity),
                stringResource(R.string.market_quantity_limits, detail.buyMax, detail.sellMax),
                Modifier.clickable(role = Role.Button, onClick = onQuantity),
            )
            Section(stringResource(R.string.market_buy_preview_title), previewBody(detail.buy))
            Section(stringResource(R.string.market_sell_preview_title), previewBody(detail.sell))
        }
        Row(Modifier.padding(start = BarteruneSpacing.Inset, bottom = MarketLayout.TradeActionBottomInset)) {
            GameButton(buyLabel(detail), onBuy, Modifier.width(MarketLayout.TradeActionWidth), enabled = detail.buy.enabled && !busy)
            Spacer(Modifier.width(BarteruneSpacing.Gap))
            GameButton(sellLabel(detail), onSell, Modifier.width(MarketLayout.TradeActionWidth), enabled = detail.sell.enabled && !busy)
        }
    }
}

@Composable
private fun previewBody(p: TradePreview): String =
    stringResource(R.string.market_preview_body, p.total, p.goldFrom, p.goldTo, p.loadFrom, p.loadTo)

@Composable
private fun buyLabel(d: GoodDetail): String = when (d.buy.blockers.size) {
    0 -> stringResource(R.string.market_buy, d.buy.total)
    1 -> stringResource(R.string.market_buy_blocked, d.buy.total, stringResource(MarketText.reason(d.buy.blockers.single())))
    else -> stringResource(R.string.market_buy_many, d.buy.blockers.size)
}

@Composable
private fun sellLabel(d: GoodDetail): String =
    if (d.sell.enabled) stringResource(R.string.market_sell, d.sell.total)
    else stringResource(R.string.market_sell_blocked, stringResource(MarketText.reason(d.sell.blockers.first())))

/** v15 detail section: title, Inset, body, then 2 × Gap. */
@Composable
private fun ColumnScope.Section(title: String, body: String, modifier: Modifier = Modifier) {
    Column(modifier.fillMaxWidth()) {
        BasicText(title, style = BarteruneTypography.SectionTitle.copy(color = BarteruneColors.TextPrimary))
        Spacer(Modifier.height(BarteruneSpacing.Inset))
        BasicText(body, style = BarteruneTypography.Body.copy(color = BarteruneColors.TextPrimary))
    }
    Spacer(Modifier.height(BarteruneSpacing.Gap * 2))
}
