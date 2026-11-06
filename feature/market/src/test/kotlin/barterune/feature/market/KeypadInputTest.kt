package barterune.feature.market

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

/** D1-input-list-v18 README input and validation rules. */
class KeypadInputTest {
    @Test fun digitAppendAndSoftCap() {
        assertEquals("2", KeypadInput.appendDigit("", '2'))
        val raw = KeypadInput.appendDigit("123456", '7')
        assertEquals("1234567", raw)
        assertEquals(KeypadProblem.DIGIT_CAP, KeypadState(raw).problem)
        assertFalse(KeypadState(raw).valid)
    }

    @Test fun signTogglePaths() {
        assertEquals("−", KeypadInput.toggleSign(""))
        assertEquals("−2", KeypadInput.toggleSign("2"))
        assertEquals("2", KeypadInput.toggleSign("−2"))
        assertEquals(KeypadProblem.MINIMUM, KeypadState("−").problem)
        assertEquals(KeypadProblem.MINIMUM, KeypadState("−2").problem)
        assertNull(KeypadState("−2").value)
    }

    @Test fun decimalPaths() {
        assertEquals("0.", KeypadInput.appendDecimal(""))
        assertEquals("−0.", KeypadInput.appendDecimal("−"))
        assertEquals("2.", KeypadInput.appendDecimal("2"))
        assertEquals("2.", KeypadInput.appendDecimal("2."))
        assertEquals("2.5", KeypadInput.appendDigit("2.", '5'))
        assertEquals(KeypadProblem.WHOLE_NUMBERS, KeypadState("2.5").problem)
        assertFalse(KeypadState("2.5").valid)
    }

    @Test fun validationOrderAndApplyValue() {
        assertEquals(KeypadProblem.MINIMUM, KeypadState("").problem)
        assertEquals(KeypadProblem.MINIMUM, KeypadState("0").problem)
        assertEquals(KeypadProblem.WHOLE_NUMBERS, KeypadState("2.5").problem)
        assertEquals(KeypadProblem.DIGIT_CAP, KeypadState("1234567").problem)
        assertTrue(KeypadState("2").valid)
        assertEquals(2, KeypadState("2").value)
        assertEquals(999999, KeypadState("999999").value)
        assertEquals(6, KeypadState("−123456").digitCount)
        assertEquals(KeypadProblem.MINIMUM, KeypadState("−123456").problem)
    }

    @Test fun userPathsFromReadme() {
        // 2 → − → −2
        var raw = KeypadInput.appendDigit("", '2')
        raw = KeypadInput.toggleSign(raw)
        assertEquals("−2", raw)
        // 2 → . → 5 → 2.5
        raw = KeypadInput.appendDigit("", '2')
        raw = KeypadInput.appendDecimal(raw)
        raw = KeypadInput.appendDigit(raw, '5')
        assertEquals("2.5", raw)
        assertFalse(KeypadState(raw).valid)
    }

    @Test fun backspace() {
        assertEquals("2.", KeypadInput.backspace("2.5"))
        assertEquals("2", KeypadInput.backspace("2."))
        assertEquals("", KeypadInput.backspace("2"))
    }
}
