package barterune.feature.market.ui

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import barterune.core.designsystem.component.GoodArt
import barterune.core.designsystem.component.ParchmentPanel
import barterune.core.designsystem.component.PixelArt
import barterune.core.designsystem.token.BarteruneColors
import barterune.core.designsystem.token.BarteruneSpacing as S
import barterune.core.designsystem.token.BarteruneTypography as Type
import barterune.feature.market.MarketActions
import barterune.feature.market.MarketUiState
import com.aladdin.barterune.feature.market.R

/**
 * D1-review-v17 P3 bounded master-detail (render-d1-review-v17.swift, values px/2): two framed maxTextWidth
 * panes, gap apart, centred, safe top to safe bottom. Left: "Bazar" and goods (48dp icon, name at +60dp,
 * row step ≥72dp). Right: good name, 96dp icon at 90dp, gold · load at 210dp, "Al / Sat" at 460dp.
 * interaction.json tablet.root: no Back row on the tablet root. The render's "Al / Sat" is static text;
 * no buy/sell controls are designed for this layout (docs/design-gaps.md).
 */
@Composable
internal fun TabletMarket(state: MarketUiState, actions: MarketActions, modifier: Modifier = Modifier) {
    Row(modifier.fillMaxSize().padding(horizontal = S.Margin), horizontalArrangement = Arrangement.spacedBy(S.Gap, androidx.compose.ui.Alignment.CenterHorizontally)) {
        ParchmentPanel(Modifier.width(S.MaxTextWidth).fillMaxHeight()) {
            Box(Modifier.fillMaxSize()) {
                Text(stringResource(R.string.t_market), Type.ScreenTitle, Modifier.padding(start = S.Inset, top = S.Inset))
                LazyColumn(Modifier.fillMaxSize(), contentPadding = PaddingValues(top = 80.dp)) {
                    items(state.rows, key = { it.goodId }) { row ->
                        Row(
                            Modifier.fillMaxWidth().heightIn(min = 72.dp).clickable { actions.onSelect(row.goodId) }
                                .padding(start = S.Inset, end = S.Inset, bottom = S.Gap),
                        ) {
                            GoodArt.of(row.goodId)?.let { PixelArt(it, Modifier.size(S.Target)) } ?: Spacer(Modifier.size(S.Target))
                            Spacer(Modifier.width(60.dp - S.Target))
                            Text(stringResource(MarketText.goodName(row.goodId)), Type.Body)
                        }
                    }
                }
            }
        }
        ParchmentPanel(Modifier.width(S.MaxTextWidth).fillMaxHeight()) {
            val d = state.detail
            Box(Modifier.fillMaxSize().padding(horizontal = S.Inset)) {
                Text(stringResource(MarketText.goodName(d.goodId)), Type.ScreenTitle, Modifier.padding(top = S.Inset))
                GoodArt.of(d.goodId)?.let { PixelArt(it, Modifier.padding(top = 90.dp).size(S.Target * 2)) }
                Text(stringResource(R.string.t_gold_load, state.gold, state.load, state.capacity), Type.Numeric, Modifier.padding(top = 210.dp))
                Text(stringResource(R.string.t_buy_sell), Type.Body, Modifier.padding(top = 460.dp))
            }
        }
    }
}

@Composable
private fun Text(text: String, style: androidx.compose.ui.text.TextStyle, modifier: Modifier = Modifier) =
    BasicText(text, modifier, style = style.copy(color = BarteruneColors.TextPrimary))
