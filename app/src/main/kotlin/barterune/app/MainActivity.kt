package barterune.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.ui.Modifier
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewmodel.initializer
import androidx.lifecycle.viewmodel.viewModelFactory
import barterune.core.designsystem.token.BarteruneColors
import barterune.feature.market.MarketRoute
import barterune.feature.market.MarketViewModel

class MainActivity : ComponentActivity() {
    private val marketViewModel: MarketViewModel by viewModels { factory }

    private val factory: ViewModelProvider.Factory by lazy {
        val container = (application as BarteruneApplication).container
        viewModelFactory { initializer { MarketViewModel(container.repository, container.marketMapper, SLOT_ID) } }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        setContent {
            MarketRoute(
                marketViewModel,
                Modifier.fillMaxSize().background(BarteruneColors.Background).windowInsetsPadding(WindowInsets.safeDrawing),
            )
        }
    }

    private companion object { const val SLOT_ID = 1 }
}
