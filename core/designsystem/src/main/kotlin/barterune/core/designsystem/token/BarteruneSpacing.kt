package barterune.core.designsystem.token

import androidx.compose.ui.unit.dp

/**
 * Source: design/states/D1-pixel-composition-tokens.json#/geometry.
 * The v15 boards render at 2 px per dp (target 96 px = the 48 dp touch minimum), so values are px / 2.
 */
object BarteruneSpacing {
    val SafeTop = 24.dp
    val SafeBottom = 24.dp
    val Margin = 12.dp
    val Gap = 12.dp
    val Inset = 12.dp
    val Target = 48.dp
    val ArtWidth = 176.dp
    val ArtHeight = 52.dp
    val FrameEdge = 6.dp
    val MaxTextWidth = 580.dp
}
