package barterune.feature.market.ui.compact

import androidx.compose.animation.Crossfade
import androidx.compose.animation.core.tween
import barterune.core.designsystem.token.BarteruneMotion
import barterune.feature.market.ui.committedTradeFade
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.runtime.key
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import barterune.core.designsystem.component.GoodArt
import barterune.core.designsystem.component.ParchmentPanel
import barterune.core.designsystem.component.PixelArt
import barterune.core.designsystem.token.BarteruneColors
import barterune.core.designsystem.token.BarteruneSpacing as S
import barterune.core.designsystem.token.BarteruneTypography
import barterune.feature.market.CompactSection
import barterune.feature.market.MarketActions
import barterune.feature.market.MarketUiState
import com.aladdin.barterune.feature.market.R

/**
 * D6 V03 phone market (D1-pixel-composition-v7 P1, reused for P2): HUD, panorama, one framed scroll panel
 * per master/detail destination, bottom navigation. The caller supplies the safe-area padding.
 */
@Composable
internal fun CompactMarketScreen(state: MarketUiState, actions: MarketActions, modifier: Modifier = Modifier) {
    Column(modifier.fillMaxSize().padding(horizontal = S.Margin)) {
        Box(Modifier.fillMaxWidth().background(BarteruneColors.Surface)) {
            // Key only by committed day: trades update gold/load immediately, without a HUD fade.
            Crossfade(targetState = state.day,
                animationSpec = tween(BarteruneMotion.DayMs, easing = BarteruneMotion.Easing),
                label = "committed-day",
            ) { day ->
                BasicText(
                    stringResource(R.string.c_hud, day, state.totalDays, state.gold, state.load, state.capacity),
                    style = BarteruneTypography.Numeric.copy(color = BarteruneColors.TextPrimary),
                    modifier = Modifier.padding(start = S.Inset, end = S.Inset, top = S.Inset / 2, bottom = S.Inset / 2),
                )
            }
        }
        Spacer(Modifier.height(S.Gap))
        PixelArt(GoodArt.MarketPanorama, Modifier.fillMaxWidth().height(S.ArtHeight))
        Spacer(Modifier.height(S.Gap))
        // New scroll position per detail destination; LIST keeps its scroll (interaction.json detailBack).
        val listScroll = rememberLazyListState()
        val tradeFade = Modifier.committedTradeFade(
            state.lastTrade.takeIf { state.section == CompactSection.TRADE_SAVED && !state.busy },
        )
        key(state.section) {
            val detailScroll = rememberLazyListState()
            CompactPanel(
                compactRows(state, actions),
                tradeFade.weight(1f).widthIn(max = S.MaxTextWidth).fillMaxWidth().align(Alignment.CenterHorizontally),
                if (state.section == CompactSection.LIST) listScroll else detailScroll,
            )
        }
        Spacer(Modifier.height(S.Gap))
        BottomNav()
    }
}
@Composable
private fun BottomNav() {
    Row(Modifier.fillMaxWidth().height(S.Target), horizontalArrangement = Arrangement.spacedBy(S.Margin)) {
        listOf(R.string.c_nav_market, R.string.c_nav_map, R.string.c_nav_cargo).forEach { label ->
            ParchmentPanel(Modifier.weight(1f).fillMaxSize()) {
                BasicText(
                    stringResource(label),
                    style = BarteruneTypography.Label.copy(color = BarteruneColors.TextPrimary),
                    maxLines = 1,
                    modifier = Modifier.padding(start = S.Inset, top = S.Inset / 2, end = S.Inset),
                )
            }
        }
    }
}
