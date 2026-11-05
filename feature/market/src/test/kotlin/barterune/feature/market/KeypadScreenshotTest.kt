package barterune.feature.market

import app.cash.paparazzi.DeviceConfig
import app.cash.paparazzi.Paparazzi
import com.android.resources.Density
import com.android.resources.ScreenOrientation
import org.junit.Rule
import org.junit.Test

/** 1280×720 px board = 640×360 dp at 2×, as D1-keypad-*.png. */
class KeypadScreenshotTest {
    @get:Rule
    val paparazzi = Paparazzi(
        deviceConfig = DeviceConfig.NEXUS_10.copy(
            screenWidth = 1280, screenHeight = 720, xdpi = 320, ydpi = 320,
            density = Density.XHIGH, orientation = ScreenOrientation.LANDSCAPE,
        ),
        showSystemUi = false,
    )

    @Test fun keypadValid() { paparazzi.snapshot { MarketScreen(MarketFixtures.p3.copy(keypad = KeypadState("2")), MarketActions()) } }

    @Test fun keypadTooLong() { paparazzi.snapshot { MarketScreen(MarketFixtures.p3.copy(keypad = KeypadState("1234567")), MarketActions()) } }
}
