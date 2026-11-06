package barterune.core.data

import barterune.engine.command.CommandResult
import barterune.engine.command.GameCommand
import barterune.engine.model.RunState
import kotlinx.coroutines.flow.Flow

/** Feature-facing save/command boundary; UI never touches DAOs or the engine's persistence. */
interface GameRepository {
    /** Loads the slot, creating a fresh run on first open. */
    suspend fun loadOrCreate(slotId: Int): RunState
    fun observe(slotId: Int): Flow<RunState?>
    /** Validates against the stored state and commits engine result + command id atomically. */
    suspend fun execute(slotId: Int, command: GameCommand): CommandResult
}
