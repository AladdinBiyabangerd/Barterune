package barterune.core.designsystem.token

import androidx.compose.ui.text.ExperimentalTextApi
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontVariation
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
import com.aladdin.barterune.core.designsystem.R

/**
 * Source: design/states/D1-canonical-render-matrix.json#/typeTrial/roles and
 * D1-font-binary-manifest.json (Noto Sans variable, wdth 100).
 */
@OptIn(ExperimentalTextApi::class)
object BarteruneTypography {
    private fun noto(weight: Int) = Font(
        R.font.noto_sans,
        FontWeight(weight),
        variationSettings = FontVariation.Settings(FontVariation.weight(weight), FontVariation.width(100f)),
    )

    val NotoSans = FontFamily(noto(400), noto(600), noto(700))

    private fun role(size: Int, line: Int, weight: Int) =
        TextStyle(fontFamily = NotoSans, fontSize = size.sp, lineHeight = line.sp, fontWeight = FontWeight(weight))

    val ScreenTitle = role(20, 28, 700)
    val SectionTitle = role(18, 24, 600)
    val Body = role(16, 24, 400)
    val Label = role(16, 24, 600)
    val Supporting = role(14, 20, 400)
    val Numeric = role(16, 24, 600)
}
