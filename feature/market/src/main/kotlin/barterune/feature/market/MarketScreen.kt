package barterune.feature.market

import androidx.activity.compose.BackHandler
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.min
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import barterune.core.designsystem.component.GameHud
import barterune.core.designsystem.component.GoodArt
import barterune.core.designsystem.component.ParchmentPanel
import barterune.core.designsystem.component.PixelArt
import barterune.core.designsystem.token.BarteruneColors
import barterune.core.designsystem.token.BarteruneSpacing
import barterune.feature.market.ui.GoodDetailPanel
import barterune.feature.market.ui.GoodList
import barterune.feature.market.ui.QuantityKeypad
import com.aladdin.barterune.feature.market.R

@Composable
fun MarketRoute(viewModel: MarketViewModel, modifier: Modifier = Modifier) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val current = state ?: return
    BackHandler(enabled = current.keypad != null) { viewModel.keypadCancel() }
    MarketScreen(
        state = current,
        actions = MarketActions(
            onSelect = viewModel::selectGood,
            onQuantity = viewModel::openKeypad,
            onBuy = viewModel::buy,
            onSell = viewModel::sell,
            onDigit = viewModel::keypadDigit,
            onBackspace = viewModel::keypadBackspace,
            onApply = viewModel::keypadApply,
            onCancel = viewModel::keypadCancel,
        ),
        modifier = modifier,
    )
}

data class MarketActions(
    val onSelect: (String) -> Unit = {},
    val onQuantity: () -> Unit = {},
    val onBuy: () -> Unit = {},
    val onSell: () -> Unit = {},
    val onDigit: (Char) -> Unit = {},
    val onBackspace: () -> Unit = {},
    val onApply: () -> Unit = {},
    val onCancel: () -> Unit = {},
)

/** D1-P3 master/detail market: HUD, panorama, goods list, selected-good detail with Al/Sat. */
@Composable
fun MarketScreen(state: MarketUiState, actions: MarketActions, modifier: Modifier = Modifier) {
    state.keypad?.let { keypad ->
        QuantityKeypad(keypad, actions.onDigit, actions.onBackspace, actions.onApply, actions.onCancel, modifier)
        return
    }
    Column(
        modifier
            .fillMaxSize()
            .background(BarteruneColors.Background)
            .padding(start = BarteruneSpacing.Margin, end = BarteruneSpacing.Margin, top = BarteruneSpacing.SafeTop, bottom = BarteruneSpacing.SafeBottom),
    ) {
        GameHud(stringResource(R.string.market_hud, state.day, state.totalDays, state.gold, state.load, state.capacity))
        Spacer(Modifier.height(BarteruneSpacing.Gap))
        PixelArt(GoodArt.MarketPanorama, Modifier.fillMaxWidth().height(BarteruneSpacing.ArtHeight))
        Spacer(Modifier.height(BarteruneSpacing.Gap))
        BoxWithConstraints(Modifier.fillMaxWidth().weight(1f)) {
            // P3 list width is maxTextWidth; narrower windows split the row evenly (no phone master/detail PNG yet).
            val listWidth = min(BarteruneSpacing.MaxTextWidth, (maxWidth - BarteruneSpacing.Gap) / 2)
            Row(Modifier.fillMaxSize()) {
                ParchmentPanel(Modifier.width(listWidth).fillMaxHeight()) {
                    GoodList(state.rows, actions.onSelect, Modifier.fillMaxSize())
                }
                Spacer(Modifier.width(BarteruneSpacing.Gap))
                ParchmentPanel(Modifier.weight(1f).fillMaxHeight()) {
                    GoodDetailPanel(state.detail, state.busy, actions.onQuantity, actions.onBuy, actions.onSell)
                }
            }
        }
    }
}
