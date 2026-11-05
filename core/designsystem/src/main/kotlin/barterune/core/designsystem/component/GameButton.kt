package barterune.core.designsystem.component

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.style.TextOverflow
import barterune.core.designsystem.token.BarteruneColors
import barterune.core.designsystem.token.BarteruneSpacing
import barterune.core.designsystem.token.BarteruneTypography

/**
 * Framed action (v15 `control()`): enabled = actionFill inside the frame with onAction text;
 * disabled = plain surface with textPrimary text. The reason must be shown as text elsewhere.
 */
@Composable
fun GameButton(text: String, onClick: () -> Unit, modifier: Modifier = Modifier, enabled: Boolean = true) {
    ParchmentPanel(
        modifier = modifier
            .heightIn(min = BarteruneSpacing.Target)
            .clickable(enabled = enabled, role = Role.Button, onClick = onClick),
        innerFill = if (enabled) BarteruneColors.ActionFill else null,
    ) {
        BasicText(
            text = text,
            style = BarteruneTypography.Label.copy(color = if (enabled) BarteruneColors.OnAction else BarteruneColors.TextPrimary),
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
            modifier = Modifier.padding(start = BarteruneSpacing.Inset, top = BarteruneSpacing.Inset / 2, end = BarteruneSpacing.Inset),
        )
    }
}
