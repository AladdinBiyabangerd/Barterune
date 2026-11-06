package barterune.core.data

import androidx.room.withTransaction
import barterune.core.database.BarteruneDatabase
import barterune.core.database.CommandLogEntity
import barterune.core.database.SaveSlotEntity
import barterune.engine.TradeEngine
import barterune.engine.command.CommandResult
import barterune.engine.command.GameCommand
import barterune.engine.model.RunState
import barterune.engine.model.RunStateCodec
import barterune.engine.run.NewRunFactory
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.util.UUID

class RoomGameRepository(
    private val db: BarteruneDatabase,
    private val engine: TradeEngine,
    private val newRuns: NewRunFactory,
    private val newRunId: () -> String = { UUID.randomUUID().toString() },
    private val newSeed: () -> Long = { kotlin.random.Random.nextLong() },
) : GameRepository {
    private val dao = db.saveSlotDao()

    override suspend fun loadOrCreate(slotId: Int): RunState = db.withTransaction {
        dao.get(slotId)?.let { RunStateCodec.decode(it.snapshotJson) }
            ?: newRuns.create(newRunId(), newSeed()).also { dao.upsert(it.toEntity(slotId)) }
    }

    override fun observe(slotId: Int): Flow<RunState?> =
        dao.observe(slotId).map { entity -> entity?.let { RunStateCodec.decode(it.snapshotJson) } }

    override suspend fun execute(slotId: Int, command: GameCommand): CommandResult = db.withTransaction {
        val current = RunStateCodec.decode(checkNotNull(dao.get(slotId)) { "Empty slot $slotId" }.snapshotJson)
        if (dao.commandCount(command.commandId) > 0) {
            // Duplicate delivery of an already-committed command: report it as stale, change nothing.
            return@withTransaction CommandResult.Rejected(listOf(barterune.engine.command.RejectReason.STALE_REVISION))
        }
        val result = engine.apply(current, command)
        if (result is CommandResult.Accepted) {
            dao.upsert(result.state.toEntity(slotId))
            dao.logCommand(CommandLogEntity(command.commandId, slotId, result.state.revision))
        }
        result
    }

    private fun RunState.toEntity(slotId: Int) =
        SaveSlotEntity(slotId, runId, revision, RunStateCodec.SCHEMA_VERSION, RunStateCodec.encode(this))
}
