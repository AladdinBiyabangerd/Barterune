package barterune.feature.market

import app.cash.paparazzi.DeviceConfig
import app.cash.paparazzi.Paparazzi
import barterune.content.ContentLoader
import barterune.engine.TradeEngine
import barterune.engine.run.NewRunFactory
import com.android.resources.Density
import com.android.resources.ScreenOrientation
import org.junit.Rule
import org.junit.Test

/** Renders at the board pixel size (2 px per dp) so output is directly comparable with design/states PNGs. */
class MarketScreenshotTest {
    @get:Rule
    val paparazzi = Paparazzi(
        deviceConfig = DeviceConfig.NEXUS_10.copy(
            screenWidth = 2560, screenHeight = 1600, xdpi = 320, ydpi = 320,
            density = Density.XHIGH, orientation = ScreenOrientation.LANDSCAPE,
        ),
        showSystemUi = false,
    )

    @Test
    fun p3MasterDetailFixture() {
        paparazzi.snapshot { MarketScreen(MarketFixtures.p3, MarketActions()) }
    }

    @Test
    fun day1RealEngineState() {
        val content = ContentLoader.loadClassic()
        val engine = TradeEngine(content)
        val state = MarketStateMapper(content, engine).map(NewRunFactory(content).create("r", 1), "grain", 1)
        paparazzi.snapshot { MarketScreen(state, MarketActions()) }
    }
}
