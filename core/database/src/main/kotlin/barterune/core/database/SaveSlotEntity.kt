package barterune.core.database

import androidx.room.Entity
import androidx.room.PrimaryKey

/** Current local snapshot of one save slot (versioned JSON payload owned by the engine codec). */
@Entity(tableName = "save_slot")
data class SaveSlotEntity(
    @PrimaryKey val slotId: Int,
    val runId: String,
    val revision: Long,
    val schemaVersion: Int,
    val snapshotJson: String,
)

/** Applied command ids; a repeated tap/retry with the same id never applies twice. */
@Entity(tableName = "command_log")
data class CommandLogEntity(
    @PrimaryKey val commandId: String,
    val slotId: Int,
    val resultingRevision: Long,
)
