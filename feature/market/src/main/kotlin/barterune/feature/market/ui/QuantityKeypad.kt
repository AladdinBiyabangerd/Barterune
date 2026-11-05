package barterune.feature.market.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import barterune.core.designsystem.component.GameButton
import barterune.core.designsystem.component.ParchmentPanel
import barterune.core.designsystem.token.BarteruneColors
import barterune.core.designsystem.token.BarteruneSpacing
import barterune.core.designsystem.token.BarteruneTypography
import barterune.feature.market.KeypadState
import com.aladdin.barterune.feature.market.R

/** D1-keypad: fixed back/context panel and all twelve keys in one frame. OK only applies the quantity. */
@Composable
internal fun QuantityKeypad(
    keypad: KeypadState,
    onDigit: (Char) -> Unit,
    onBackspace: () -> Unit,
    onApply: () -> Unit,
    onCancel: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Row(
        modifier
            .fillMaxSize()
            .background(BarteruneColors.Background)
            .padding(start = BarteruneSpacing.Margin, end = BarteruneSpacing.Margin, top = BarteruneSpacing.SafeTop, bottom = BarteruneSpacing.SafeBottom),
    ) {
        ParchmentPanel(Modifier.width(BarteruneSpacing.ArtWidth).fillMaxHeight()) {
            Column(Modifier.padding(BarteruneSpacing.Inset)) {
                GameButton(stringResource(R.string.keypad_back), onCancel, Modifier.fillMaxWidth().height(BarteruneSpacing.Target))
                Spacer(Modifier.height(BarteruneSpacing.Inset))
                BasicText(
                    stringResource(R.string.keypad_title, keypad.raw.ifEmpty { "—" }),
                    style = BarteruneTypography.ScreenTitle.copy(color = BarteruneColors.TextPrimary),
                )
                Spacer(Modifier.height(BarteruneSpacing.Inset))
                BasicText(
                    stringResource(if (keypad.valid) R.string.keypad_valid else R.string.keypad_invalid),
                    style = BarteruneTypography.Body.copy(color = BarteruneColors.TextPrimary),
                )
            }
        }
        Spacer(Modifier.width(BarteruneSpacing.Gap))
        Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(BarteruneSpacing.Gap)) {
            listOf("123", "456", "789", "←0✓").forEach { keys ->
                Row(horizontalArrangement = Arrangement.spacedBy(BarteruneSpacing.Gap)) {
                    keys.forEach { key ->
                        val keyModifier = Modifier.weight(1f).height(BarteruneSpacing.Target)
                        when (key) {
                            '←' -> {
                                val label = stringResource(R.string.keypad_backspace)
                                GameButton("←", onBackspace, keyModifier.semantics { contentDescription = label })
                            }
                            '✓' -> {
                                val label = stringResource(R.string.keypad_apply)
                                GameButton("✓", onApply, keyModifier.semantics { contentDescription = label }, enabled = keypad.valid)
                            }
                            else -> GameButton(key.toString(), { onDigit(key) }, keyModifier)
                        }
                    }
                }
            }
        }
    }
}
