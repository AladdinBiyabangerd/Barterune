package barterune.feature.market

import androidx.compose.animation.core.Animatable
import androidx.compose.runtime.MonotonicFrameClock
import androidx.compose.ui.MotionDurationScale
import barterune.feature.market.ui.revealCommittedTrade
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.advanceTimeBy
import kotlinx.coroutines.test.runCurrent
import kotlinx.coroutines.test.runTest
import org.junit.Assert.*
import org.junit.Test

@OptIn(ExperimentalCoroutinesApi::class)
class MarketMotionTest {
    private class Scale(override var scaleFactor: Float) : MotionDurationScale

    @Test fun tradeCompletesAfter180msOfFrames() = runTest {
        val clock = object : MonotonicFrameClock {
            override suspend fun <R> withFrameNanos(onFrame: (Long) -> R): R {
                delay(10)
                return onFrame(testScheduler.currentTime * 1_000_000)
            }
        }
        val alpha = Animatable(1f)
        val job = launch(clock + Scale(1f)) { revealCommittedTrade(alpha) }
        runCurrent()
        assertEquals(0f, alpha.value)
        advanceTimeBy(100); runCurrent()
        assertTrue(alpha.value > 0f && alpha.value < 1f)
        assertFalse(job.isCompleted)
        advanceTimeBy(80); runCurrent()
        assertFalse(job.isCompleted) // first frame was at 10ms; only 170ms have elapsed
        advanceTimeBy(10); runCurrent()
        assertEquals(1f, alpha.value)
        assertTrue(job.isCompleted)
    }

    @Test fun disabledMotionShowsResultWithoutRequestingAFrame() = runTest {
        val alpha = Animatable(0.3f)
        val job = launch(Scale(0f)) { revealCommittedTrade(alpha) }
        runCurrent()
        assertTrue(job.isCompleted)
        assertEquals(1f, alpha.value)
        assertEquals(0L, testScheduler.currentTime)
    }

    @Test fun disablingMotionDuringTradeFinishesWithinTwoFrames() = runTest {
        val scale = Scale(1f)
        val clock = object : MonotonicFrameClock {
            override suspend fun <R> withFrameNanos(onFrame: (Long) -> R): R {
                delay(10)
                return onFrame(testScheduler.currentTime * 1_000_000)
            }
        }
        val alpha = Animatable(1f)
        val job = launch(clock + scale) { revealCommittedTrade(alpha) }
        advanceTimeBy(80); runCurrent()
        assertTrue(alpha.value < 1f)
        // Compose 1.7 reads scale before awaiting a frame; one frame may already be in flight.
        scale.scaleFactor = 0f
        advanceTimeBy(20); runCurrent()
        assertTrue(job.isCompleted)
        assertEquals(1f, alpha.value)
    }
}
