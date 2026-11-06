package barterune.core.database

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Upsert
import kotlinx.coroutines.flow.Flow

@Dao
interface SaveSlotDao {
    @Query("SELECT * FROM save_slot WHERE slotId = :slotId")
    suspend fun get(slotId: Int): SaveSlotEntity?

    @Query("SELECT * FROM save_slot WHERE slotId = :slotId")
    fun observe(slotId: Int): Flow<SaveSlotEntity?>

    @Upsert
    suspend fun upsert(slot: SaveSlotEntity)

    @Query("SELECT COUNT(*) FROM command_log WHERE commandId = :commandId")
    suspend fun commandCount(commandId: String): Int

    @Insert(onConflict = OnConflictStrategy.ABORT)
    suspend fun logCommand(entry: CommandLogEntity)
}
