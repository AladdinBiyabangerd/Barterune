package barterune.feature.market.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.BasicText
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.min
import barterune.core.designsystem.component.GameButton
import barterune.core.designsystem.token.BarteruneColors
import barterune.core.designsystem.token.BarteruneSpacing
import barterune.core.designsystem.token.BarteruneTypography
import barterune.feature.market.KeypadProblem
import barterune.feature.market.KeypadState
import com.aladdin.barterune.feature.market.R

/**
 * D1-keypad-fixed-v16 (render-d1-keypad-fixed-v16.swift): two equal panes. Left: scrollable instructions
 * (enter quantity, good, rule) above a fixed "← Geri". Right: value field and the 12 keys, top-aligned on
 * phones, vertically centred on tablets where the pair is bounded to 2×maxTextWidth and centred.
 * Back cancels and restores the prior quantity; ✓ only applies the quantity.
 */
@Composable
internal fun QuantityKeypad(
    keypad: KeypadState,
    goodId: String,
    tablet: Boolean,
    onDigit: (Char) -> Unit,
    onBackspace: () -> Unit,
    onApply: () -> Unit,
    onCancel: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val gap = BarteruneSpacing.Gap
    val inset = BarteruneSpacing.Inset
    BoxWithConstraints(modifier.fillMaxSize().padding(horizontal = BarteruneSpacing.Margin), contentAlignment = Alignment.TopCenter) {
        val totalW = if (tablet) min(maxWidth, BarteruneSpacing.MaxTextWidth * 2) else maxWidth
        Row(Modifier.width(totalW).fillMaxHeight(), horizontalArrangement = Arrangement.spacedBy(gap)) {
            Column(Modifier.weight(1f).fillMaxHeight(), verticalArrangement = Arrangement.spacedBy(gap)) {
                Column(
                    Modifier.weight(1f).fillMaxWidth().background(BarteruneColors.Surface).verticalScroll(rememberScrollState()),
                    verticalArrangement = Arrangement.spacedBy(gap),
                ) {
                    val reason = when (keypad.problem) {
                        null -> R.string.c_editing
                        KeypadProblem.MINIMUM -> R.string.c_minimum
                        KeypadProblem.DIGIT_CAP -> R.string.c_digit_cap
                    }
                    InfoLine(stringResource(R.string.c_enter_quantity), BarteruneTypography.Label)
                    InfoLine(stringResource(MarketText.goodName(goodId)), BarteruneTypography.SectionTitle)
                    InfoLine(stringResource(reason), BarteruneTypography.Supporting)
                }
                GameButton(stringResource(R.string.keypad_back), onCancel, Modifier.fillMaxWidth())
            }
            Column(
                Modifier.weight(1f).fillMaxHeight(),
                verticalArrangement = Arrangement.spacedBy(gap, if (tablet) Alignment.CenterVertically else Alignment.Top),
            ) {
                Box(
                    Modifier.fillMaxWidth().heightIn(min = BarteruneSpacing.Target).background(BarteruneColors.Surface).padding(horizontal = inset),
                    contentAlignment = Alignment.CenterStart,
                ) {
                    BasicText(keypad.raw.ifEmpty { "—" }, style = BarteruneTypography.Numeric.copy(color = BarteruneColors.TextPrimary))
                }
                listOf("123", "456", "789", "←0✓").forEach { keys ->
                    Row(horizontalArrangement = Arrangement.spacedBy(gap)) {
                        keys.forEach { key ->
                            val keyModifier = Modifier.weight(1f)
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
}

@Composable
private fun InfoLine(text: String, style: TextStyle) {
    BasicText(
        text,
        style = style.copy(color = BarteruneColors.TextPrimary),
        modifier = Modifier.fillMaxWidth().padding(horizontal = BarteruneSpacing.Inset).padding(top = BarteruneSpacing.Inset / 2, bottom = BarteruneSpacing.Inset / 2),
    )
}
