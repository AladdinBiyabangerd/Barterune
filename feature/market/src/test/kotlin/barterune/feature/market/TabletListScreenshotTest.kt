package barterune.feature.market

import androidx.compose.foundation.lazy.LazyListState
import androidx.compose.ui.Modifier
import app.cash.paparazzi.DeviceConfig
import app.cash.paparazzi.Paparazzi
import barterune.feature.market.ui.TabletMarket
import com.android.resources.Density
import com.android.resources.ScreenOrientation
import org.junit.Rule
import org.junit.Test

/** D1-input-list-v18 P3 list scroll-0 / scroll-7 goldens. */
class TabletListScreenshotTest {
    @get:Rule
    val paparazzi = Paparazzi(
        deviceConfig = DeviceConfig.NEXUS_10.copy(
            screenWidth = 2560, screenHeight = 1600,
            xdpi = Density.XHIGH.dpiValue, ydpi = Density.XHIGH.dpiValue,
            density = Density.XHIGH, orientation = ScreenOrientation.LANDSCAPE,
        ),
        showSystemUi = false,
        useDeviceResolution = true,
    )

    @Test fun listScroll0() {
        paparazzi.snapshot("list-scroll-0") {
            TabletMarket(MarketFixtures.p3, MarketActions(), Modifier, LazyListState(0, 0))
        }
    }

    @Test fun listScroll7() {
        paparazzi.snapshot("list-scroll-7") {
            TabletMarket(MarketFixtures.p3, MarketActions(), Modifier, LazyListState(7, 0))
        }
    }
}
