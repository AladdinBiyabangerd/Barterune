package barterune.feature.market

import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.ui.unit.dp
import app.cash.paparazzi.DeviceConfig
import app.cash.paparazzi.Paparazzi
import com.android.resources.Density
import com.android.resources.ScreenOrientation
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

/** D1-canonical-render-matrix profiles at board pixel size, so renders compare 1:1 with design/states PNGs. */
enum class Profile(val widthPx: Int, val heightPx: Int, val density: Density, val leftInsetDp: Int) {
    P1(1280, 720, Density.XHIGH, 0),
    P2(2400, 1080, Density.XXHIGH, 32),
    P3(2560, 1600, Density.XHIGH, 0),
}

@RunWith(Parameterized::class)
class MarketProfileScreenshotTest(private val profile: Profile) {
    companion object {
        @JvmStatic @Parameterized.Parameters(name = "{0}")
        fun profiles() = Profile.entries.map { arrayOf<Any>(it) }
    }

    @get:Rule
    val paparazzi = Paparazzi(
        deviceConfig = DeviceConfig.NEXUS_10.copy(
            screenWidth = profile.widthPx, screenHeight = profile.heightPx,
            xdpi = profile.density.dpiValue, ydpi = profile.density.dpiValue,
            density = profile.density, orientation = ScreenOrientation.LANDSCAPE,
        ),
        showSystemUi = false,
        // Keep board resolution (default downsizes to 1000 px) so pixel art compares 1:1.
        useDeviceResolution = true,
    )

    private fun shot(name: String, state: MarketUiState) = paparazzi.snapshot(name) {
        MarketScreen(state, MarketActions(), safeInsets = WindowInsets(left = profile.leftInsetDp.dp, top = 24.dp, bottom = 24.dp))
    }

    private val base = MarketFixtures.p3

    @Test fun list() = shot("list", base)
    @Test fun good() = shot("good", base.copy(section = CompactSection.GOOD))
    @Test fun batches() = shot("batches", base.copy(section = CompactSection.BATCHES))
    @Test fun buyPreview() = shot("buyPreview", base.copy(section = CompactSection.BUY_PREVIEW))
    @Test fun sellPreview() = shot("sellPreview", base.copy(section = CompactSection.SELL_PREVIEW))
    @Test fun quantity() = shot("quantity", base.copy(section = CompactSection.QUANTITY, keypad = KeypadState("2")))
    @Test fun quantityEmpty() = shot("quantity-empty", base.copy(section = CompactSection.QUANTITY, keypad = KeypadState("")))
    @Test fun quantitySevenDigits() = shot("quantity-seven-digits", base.copy(section = CompactSection.QUANTITY, keypad = KeypadState("1234567")))
}
