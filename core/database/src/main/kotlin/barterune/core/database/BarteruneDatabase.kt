package barterune.core.database

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(entities = [SaveSlotEntity::class, CommandLogEntity::class], version = 1, exportSchema = true)
abstract class BarteruneDatabase : RoomDatabase() {
    abstract fun saveSlotDao(): SaveSlotDao

    companion object {
        const val NAME = "barterune.db"
        fun build(context: Context, name: String = NAME): BarteruneDatabase =
            Room.databaseBuilder(context, BarteruneDatabase::class.java, name).build()
    }
}
