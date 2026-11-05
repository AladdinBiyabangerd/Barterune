package barterune.engine.command

import barterune.engine.model.RunState

sealed interface CommandResult {
    data class Accepted(val state: RunState, val ledger: LedgerDelta) : CommandResult
    data class Rejected(val reasons: List<RejectReason>) : CommandResult
}

/** Effect of one accepted command; [unitPrice] is the quote used. */
data class LedgerDelta(val goodId: String, val quantity: Int, val unitPrice: Long, val goldDelta: Long, val loadDelta: Int)

enum class RejectReason {
    STALE_REVISION,
    INVALID_QUANTITY,
    UNKNOWN_GOOD,
    UNKNOWN_BATCH,
    OUT_OF_STOCK,
    NOT_ENOUGH_GOLD,
    NOT_ENOUGH_CAPACITY,
    NOT_ENOUGH_IN_BATCH,
    AMOUNT_OVERFLOW,
}
