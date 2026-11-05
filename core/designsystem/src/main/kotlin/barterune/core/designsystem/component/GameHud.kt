package barterune.core.designsystem.component

import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import barterune.core.designsystem.token.BarteruneColors
import barterune.core.designsystem.token.BarteruneSpacing
import barterune.core.designsystem.token.BarteruneTypography

/** Fixed status line: day · gold · load. */
@Composable
fun GameHud(status: String, modifier: Modifier = Modifier) {
    ParchmentPanel(modifier.fillMaxWidth().height(BarteruneSpacing.Target)) {
        BasicText(
            text = status,
            style = BarteruneTypography.Numeric.copy(color = BarteruneColors.TextPrimary),
            maxLines = 1,
            modifier = Modifier.padding(start = BarteruneSpacing.Margin, top = BarteruneSpacing.Inset).semantics { heading() },
        )
    }
}
