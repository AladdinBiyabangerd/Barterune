package barterune.app

import android.content.Context
import barterune.content.ContentLoader
import barterune.core.data.GameRepository
import barterune.core.data.RoomGameRepository
import barterune.core.database.BarteruneDatabase
import barterune.engine.TradeEngine
import barterune.engine.run.NewRunFactory
import barterune.feature.market.MarketStateMapper

/** Manual wiring for the M1 prototype (Hilt is planned once more features exist). */
class AppContainer(context: Context) {
    val content = ContentLoader.loadClassic()
    val engine = TradeEngine(content)
    private val database = BarteruneDatabase.build(context)
    val repository: GameRepository = RoomGameRepository(database, engine, NewRunFactory(content))
    val marketMapper = MarketStateMapper(content, engine)
}
