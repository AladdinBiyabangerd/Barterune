package barterune.feature.market

import androidx.activity.compose.BackHandler
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.union
import androidx.compose.foundation.layout.windowInsetsPadding
import barterune.feature.market.ui.compact.CompactMarketScreen
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
import barterune.feature.market.ui.TabletMarket
import androidx.compose.ui.unit.Dp
import com.aladdin.barterune.feature.market.R

@Composable
fun MarketRoute(viewModel: MarketViewModel, modifier: Modifier = Modifier) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val current = state ?: return
    BackHandler(enabled = current.keypad != null || current.section != CompactSection.LIST) {
        if (current.keypad != null) viewModel.keypadCancel() else viewModel.backToMarket()
    }
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
            onBackToMarket = viewModel::backToMarket,
            onOpenGood = viewModel::openGood,
            onNavigate = viewModel::navigate,
            onSelectBatch = viewModel::selectBatch,
            onApplyMax = viewModel::applyMax,
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
    val onBackToMarket: () -> Unit = {},
    val onOpenGood: (String) -> Unit = {},
    val onNavigate: (CompactSection) -> Unit = {},
    val onSelectBatch: (String) -> Unit = {},
    val onApplyMax: (Int) -> Unit = {},
)

/**
 * Design minimum safe area (D1-canonical-render-matrix: top/bottom 24 dp). Combined with system bars/cutout
 * as a per-edge maximum, never added twice.
 */
val DesignSafeInsets = WindowInsets(top = BarteruneSpacing.SafeTop, bottom = BarteruneSpacing.SafeBottom)

/** Two existing 580dp panes plus outer margins and the gap, measured after safe insets. */
val DefaultTabletMinWidth: Dp = BarteruneSpacing.MaxTextWidth * 2 +
    BarteruneSpacing.Margin * 2 + BarteruneSpacing.Gap

/**
 * Market: D1 v7 composition on phones (P1 v7, P2 D1-device-matrix-v15), D1-review-v17 master-detail on tablets; quantity uses D1-keypad-fixed-v16.
 */
@Composable
fun MarketScreen(
    state: MarketUiState,
    actions: MarketActions,
    modifier: Modifier = Modifier,
    tabletMinWidth: Dp = DefaultTabletMinWidth,
    safeInsets: WindowInsets = WindowInsets.safeDrawing.union(DesignSafeInsets),
) {
    BoxWithConstraints(modifier.fillMaxSize().background(BarteruneColors.Background).windowInsetsPadding(safeInsets)) {
        val inner = Modifier
        val keypad = state.keypad
        // Constraints already exclude safe insets; resizing preserves the hoisted screen state.
        val tablet = maxWidth >= tabletMinWidth
        if (keypad != null) QuantityKeypad(keypad, state.detail.goodId, tablet, actions.onDigit, actions.onBackspace, actions.onApply, actions.onCancel, inner)
        else if (tablet) TabletMarket(state, actions, inner)
        else CompactMarketScreen(state, actions, inner)
    }
}
