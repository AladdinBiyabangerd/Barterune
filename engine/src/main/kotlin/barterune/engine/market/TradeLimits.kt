package barterune.engine.market

/** Quantity field bounds from designResolutions/D1-quantity-review. */
object TradeLimits {
    const val MAX_QUANTITY = 999_999

    /** min(floor(gold/unit), floor(free load/unitLoad), stock, 999999). */
    fun buyMax(gold: Long, unitPrice: Long, freeLoad: Int, unitLoad: Int, stock: Int): Int {
        val byGold = if (unitPrice <= 0) 0L else gold / unitPrice
        val byLoad = if (unitLoad <= 0) 0 else freeLoad / unitLoad
        return minOf(byGold, byLoad.toLong(), stock.toLong(), MAX_QUANTITY.toLong()).coerceAtLeast(0).toInt()
    }

    /** min(selected batch quantity, 999999). */
    fun sellMax(batchQuantity: Int): Int = minOf(batchQuantity, MAX_QUANTITY).coerceAtLeast(0)
}
