package barterune.feature.market

/** Pure D1-input-list-v18 keypad edits. Sign and `.` are not digits toward the 6-digit cap. */
object KeypadInput {
    fun appendDigit(raw: String, digit: Char): String {
        require(digit in '0'..'9')
        val digits = raw.count { it.isDigit() }
        if (digits >= KeypadState.DIGIT_SOFT_CAP) return raw
        return raw + digit
    }

    fun backspace(raw: String): String = raw.dropLast(1)

    /** Toggles a leading −; empty draft becomes only − (apply stays disabled). */
    fun toggleSign(raw: String): String =
        if (raw.startsWith(KeypadState.SIGN)) raw.drop(1) else KeypadState.SIGN + raw

    /** Appends `.` once. Empty → `0.`; sign-only → `−0.`; second `.` is ignored. */
    fun appendDecimal(raw: String): String = when {
        '.' in raw -> raw
        raw.isEmpty() -> "0."
        raw == KeypadState.SIGN -> KeypadState.SIGN + "0."
        else -> raw + "."
    }
}
