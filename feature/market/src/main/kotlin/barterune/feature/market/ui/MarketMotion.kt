package barterune.feature.market.ui

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.AnimationVector1D
import androidx.compose.animation.core.tween
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.MotionDurationScale
import androidx.compose.ui.graphics.graphicsLayer
import barterune.core.designsystem.token.BarteruneMotion
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.currentCoroutineContext
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch

/** Fade only newly committed content; never retain outgoing controls or delay repository work.
 * Compose supplies Android's live animator-duration scale to the effect's coroutine context.
 */
@Composable
internal fun Modifier.committedTradeFade(event: Any?): Modifier {
    val alpha = remember { Animatable(1f) }
    val initialEvent = remember { event }
    // No entrance animation on restoration/resize. Only changes observed by this composition animate.
    val previous = remember { arrayOf(initialEvent) }
    LaunchedEffect(event) {
        val changed = previous[0] != event
        previous[0] = event
        if (changed && event != null) revealCommittedTrade(alpha) else alpha.snapTo(1f)
    }
    return graphicsLayer { this.alpha = alpha.value }
}

internal suspend fun revealCommittedTrade(alpha: Animatable<Float, AnimationVector1D>) {
    if (currentCoroutineContext()[MotionDurationScale]?.scaleFactor == 0f) {
        alpha.snapTo(1f)
        return
    }
    alpha.snapTo(0f)
    // animateTo uses MotionDurationScale at start. Poll without consuming animation frames so a
    // mid-flight reduced-motion change can snap the result (system scale or unit-test Scale).
    coroutineScope {
        val anim = launch {
            alpha.animateTo(1f, tween(BarteruneMotion.TradeMs, easing = BarteruneMotion.Easing))
        }
        val watcher = launch {
            while (isActive && anim.isActive) {
                if (currentCoroutineContext()[MotionDurationScale]?.scaleFactor == 0f) {
                    anim.cancel()
                    alpha.snapTo(1f)
                    return@launch
                }
                delay(1)
            }
        }
        anim.join()
        watcher.cancel()
    }
}
