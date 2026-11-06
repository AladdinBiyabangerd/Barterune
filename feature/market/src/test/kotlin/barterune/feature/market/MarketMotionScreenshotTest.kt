package barterune.feature.market

import android.view.ViewGroup
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.platform.ComposeView
import app.cash.paparazzi.DeviceConfig
import app.cash.paparazzi.Paparazzi
import com.android.resources.ScreenOrientation
import kotlinx.coroutines.delay
import org.junit.Rule
import org.junit.Test

class MarketMotionScreenshotTest {
    @get:Rule val paparazzi = Paparazzi(
        deviceConfig = DeviceConfig.PIXEL_5.copy(orientation = ScreenOrientation.LANDSCAPE),
        showSystemUi = false,
    )

    @Test fun committedDayAndTrade() {
        val view = ComposeView(paparazzi.context).apply {
            layoutParams = ViewGroup.LayoutParams(-1, -1)
            setContent {
                var committed by remember { mutableStateOf(false) }
                LaunchedEffect(Unit) { delay(100); committed = true }
                val base = MarketFixtures.p3
                MarketScreen(
                    base.copy(
                        day = if (committed) base.day + 1 else base.day,
                        section = if (committed) CompactSection.TRADE_SAVED else CompactSection.BUY_PREVIEW,
                        lastTrade = if (committed) TradeOutcome(true) else null,
                    ),
                    MarketActions(), safeInsets = WindowInsets(0, 0, 0, 0),
                )
            }
        }
        paparazzi.gif(view, name = "committed-day-trade", end = 500, fps = 20)
    }
}
