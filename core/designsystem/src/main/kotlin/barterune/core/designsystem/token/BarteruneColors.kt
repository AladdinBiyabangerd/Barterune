package barterune.core.designsystem.token

import androidx.compose.ui.graphics.Color

/**
 * Source: design/states/D6-canonical-token-proposal.json (referenceColors + semanticColors).
 * Only the proposed roles exist; pending roles (focus, pressed, error, scrim…) stay unresolved on purpose.
 */
object BarteruneColors {
    // referenceColors
    val Paper = Color(0xFFFCECD0)
    val Ink = Color(0xFF882316)
    val Nav = Color(0xFF1A3546)

    // semanticColors
    val Surface = Paper
    val TextPrimary = Nav
    val ActionFill = Nav
    val OnAction = Paper
    val EmphasisText = Ink

    /** Screen background as drawn by every v15 board (box(..., "nav")). */
    val Background = Nav
}
