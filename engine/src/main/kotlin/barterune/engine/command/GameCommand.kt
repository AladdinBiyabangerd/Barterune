package barterune.engine.command

/** Engine command. [expectedRevision] guards against acting on a stale quote. */
sealed interface GameCommand {
    val commandId: String
    val expectedRevision: Long
}

data class BuyGoods(
    override val commandId: String,
    override val expectedRevision: Long,
    val goodId: String,
    val quantity: Int,
) : GameCommand

data class SellBatch(
    override val commandId: String,
    override val expectedRevision: Long,
    val batchId: String,
    val quantity: Int,
) : GameCommand
