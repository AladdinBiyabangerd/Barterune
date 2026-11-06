package barterune.feature.market.ui

import androidx.compose.foundation.background
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
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyListState
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.runtime.derivedStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
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
 * D1-input-list-v18 P3 list: classic-v1 order, independently scrolling left pane, selection kept on the
 * right. Header "Bazar · N mal"; footer shows visible range and scroll hint. Right pane keeps the
 * selected good while the list scrolls (demo copy: selection preserved).
 */
@Composable
internal fun TabletMarket(
    state: MarketUiState,
    actions: MarketActions,
    modifier: Modifier = Modifier,
    listState: LazyListState = rememberLazyListState(),
) {
    val total = state.rows.size
    val visible by remember(listState, total) {
        derivedStateOf {
            val info = listState.layoutInfo
            val visibleItems = info.visibleItemsInfo
            if (visibleItems.isEmpty()) 1 to minOf(7, total)
            else {
                val first = visibleItems.first().index + 1
                val last = visibleItems.last().index + 1
                first to last
            }
        }
    }
    Row(
        modifier.fillMaxSize().padding(horizontal = S.Margin),
        horizontalArrangement = Arrangement.spacedBy(S.Gap, androidx.compose.ui.Alignment.CenterHorizontally),
    ) {
        ParchmentPanel(Modifier.width(S.MaxTextWidth).fillMaxHeight()) {
            Column(Modifier.fillMaxSize()) {
                Text(
                    stringResource(R.string.t_market_count, total),
                    Type.ScreenTitle,
                    Modifier.padding(start = S.Inset, top = S.Inset, end = S.Inset),
                )
                LazyColumn(
                    state = listState,
                    modifier = Modifier.weight(1f).fillMaxWidth(),
                    contentPadding = PaddingValues(top = S.Gap, bottom = S.Gap),
                ) {
                    itemsIndexed(state.rows, key = { _, row -> row.goodId }) { index, row ->
                        val selected = row.selected
                        Row(
                            Modifier
                                .fillMaxWidth()
                                .heightIn(min = 72.dp)
                                .then(if (selected) Modifier.background(BarteruneColors.OnAction.copy(alpha = 0.35f)) else Modifier)
                                .clickable {
                                    // Select + open compact v20 detail so trading is reachable on tablet
                                    // without inventing a P3 trade chrome (v20 is P1-only).
                                    actions.onOpenGood(row.goodId)
                                }
                                .padding(start = S.Inset, end = S.Inset, bottom = S.Gap),
                        ) {
                            GoodArt.of(row.goodId)?.let { PixelArt(it, Modifier.size(S.Target)) }
                                ?: Spacer(Modifier.size(S.Target))
                            Spacer(Modifier.width(60.dp - S.Target))
                            Text(
                                stringResource(R.string.t_good_indexed, index + 1, stringResource(MarketText.goodName(row.goodId))),
                                Type.Body,
                            )
                        }
                    }
                }
                val (first, last) = visible
                val atEnd = last >= total && first > 1
                Text(
                    if (atEnd) stringResource(R.string.t_scroll_up, first, last, total)
                    else stringResource(R.string.t_scroll_down, first, last, total),
                    Type.Supporting,
                    Modifier.padding(start = S.Inset, end = S.Inset, bottom = S.Inset),
                )
            }
        }
        ParchmentPanel(Modifier.width(S.MaxTextWidth).fillMaxHeight()) {
            val d = state.detail
            Box(Modifier.fillMaxSize().padding(horizontal = S.Inset)) {
                Text(stringResource(MarketText.goodName(d.goodId)), Type.ScreenTitle, Modifier.padding(top = S.Inset))
                GoodArt.of(d.goodId)?.let { PixelArt(it, Modifier.padding(top = 90.dp).size(S.Target * 2)) }
                Text(
                    stringResource(R.string.t_selection_kept),
                    Type.Body,
                    Modifier.padding(top = 210.dp),
                )
            }
        }
    }
}

@Composable
private fun Text(text: String, style: androidx.compose.ui.text.TextStyle, modifier: Modifier = Modifier) =
    BasicText(text, modifier, style = style.copy(color = BarteruneColors.TextPrimary))
