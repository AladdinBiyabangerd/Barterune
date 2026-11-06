package barterune.core.designsystem.token

import androidx.compose.animation.core.CubicBezierEasing

/** D1-review-v17/motion.json; selected under the 2026-11-05 delegated design decision.
 * Visual durations only: never delay commands, persistence, or pending/error state.
 * Consumers must use ReducedMotionMs when system motion is disabled.
 */
object BarteruneMotion {
    const val TravelMs = 800
    const val DayMs = 240
    const val TradeMs = 180
    const val ReducedMotionMs = 0
    val Easing = CubicBezierEasing(0.4f, 0f, 0.2f, 1f)
}
