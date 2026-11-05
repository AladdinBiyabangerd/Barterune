package barterune.core.designsystem.component

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxScope
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.graphics.FilterQuality
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.res.imageResource
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.IntSize
import barterune.core.designsystem.token.BarteruneColors
import barterune.core.designsystem.token.BarteruneSpacing
import com.aladdin.barterune.core.designsystem.R

/** Paper surface with the stretched wooden frame edges (v15 `frame()`). */
@Composable
fun ParchmentPanel(modifier: Modifier = Modifier, content: @Composable BoxScope.() -> Unit = {}) {
    val top = ImageBitmap.imageResource(R.drawable.frame_top)
    val bottom = ImageBitmap.imageResource(R.drawable.frame_bottom)
    val left = ImageBitmap.imageResource(R.drawable.frame_left)
    val right = ImageBitmap.imageResource(R.drawable.frame_right)
    Box(
        modifier = modifier
            .background(BarteruneColors.Surface)
            .drawWithContent {
                drawContent()
                val e = BarteruneSpacing.FrameEdge.toPx().toInt()
                val w = size.width.toInt()
                val h = size.height.toInt()
                stretch(top, 0, 0, w, e)
                stretch(bottom, 0, h - e, w, e)
                stretch(left, 0, e, e, h - 2 * e)
                stretch(right, w - e, e, e, h - 2 * e)
            },
        content = content,
    )
}

internal fun DrawScope.stretch(image: ImageBitmap, x: Int, y: Int, w: Int, h: Int) {
    if (w <= 0 || h <= 0) return
    drawImage(image, dstOffset = IntOffset(x, y), dstSize = IntSize(w, h), filterQuality = FilterQuality.None)
}
