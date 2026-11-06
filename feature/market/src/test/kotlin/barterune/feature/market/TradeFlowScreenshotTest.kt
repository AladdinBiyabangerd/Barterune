package barterune.feature.market

import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.lazy.LazyListState
import androidx.compose.ui.unit.dp
import app.cash.paparazzi.DeviceConfig
import app.cash.paparazzi.Paparazzi
import com.android.resources.Density
import com.android.resources.ScreenOrientation
import org.junit.Rule
import org.junit.Test

/** D1-trade-flow-v20 entry and preview screens (full phone chrome; scroll to reveal lower rows). */
class TradeFlowScreenshotTest {
    @get:Rule
    val paparazzi = Paparazzi(
        deviceConfig = DeviceConfig.NEXUS_10.copy(
            screenWidth = 1280, screenHeight = 720,
            xdpi = Density.XHIGH.dpiValue, ydpi = Density.XHIGH.dpiValue,
            density = Density.XHIGH, orientation = ScreenOrientation.LANDSCAPE,
        ),
        showSystemUi = false,
        useDeviceResolution = true,
    )

    private fun shot(name: String, state: MarketUiState) = paparazzi.snapshot(name) {
        MarketScreen(state, MarketActions(), safeInsets = WindowInsets(0.dp, 24.dp, 0.dp, 24.dp))
    }

    private val base = MarketFixtures.p3

    @Test fun detail() = shot("v20-detail", base.copy(section = CompactSection.GOOD))
    @Test fun buy() = shot("v20-buy", base.copy(section = CompactSection.BUY_PREVIEW))
    @Test fun sell() = shot("v20-sell", base.copy(section = CompactSection.SELL_PREVIEW))
    @Test fun blockedSell() = shot(
        "v20-blocked",
        base.copy(
            section = CompactSection.SELL_PREVIEW,
            detail = base.detail.copy(
                quantity = 6,
                sell = base.detail.sell.copy(
                    blockers = listOf(barterune.engine.command.RejectReason.NOT_ENOUGH_IN_BATCH),
                    total = 0, goldTo = 500, loadTo = 16,
                ),
            ),
        ),
    )
}
