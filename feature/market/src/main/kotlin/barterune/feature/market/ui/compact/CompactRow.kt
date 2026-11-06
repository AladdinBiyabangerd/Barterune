package barterune.feature.market.ui.compact

import androidx.annotation.DrawableRes
import androidx.compose.ui.text.TextStyle

/**
 * One block of the D1-pixel-composition-v7 scroll panel (`Row` in render-d1-pixel-composition.swift):
 * an optional action (nav fill), optional icon and optional paired action.
 */
internal data class CompactRow(
    val text: String,
    val style: TextStyle,
    val onClick: (() -> Unit)? = null,
    val enabled: Boolean = onClick != null,
    @DrawableRes val icon: Int? = null,
    val pair: CompactRow? = null,
)
