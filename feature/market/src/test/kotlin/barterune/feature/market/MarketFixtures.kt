package barterune.feature.market

/** D1-render-fixture.json base state (T01/T02) as drawn by D1-P3-master-detail.png. */
object MarketFixtures {
    private val prices = listOf(
        "grain" to listOf(12L, 9L, 40L, 1L), "wood" to listOf(20L, 15L, 25L, 2L), "cloth" to listOf(35L, 28L, 30L, 2L),
        "spices" to listOf(60L, 45L, 14L, 1L), "iron" to listOf(48L, 36L, 18L, 3L), "salt" to listOf(10L, 7L, 50L, 1L),
        "wool" to listOf(24L, 18L, 22L, 1L), "herbs" to listOf(32L, 23L, 16L, 1L),
        "mana_crystal" to listOf(150L, 110L, 6L, 1L), "dragon_resin" to listOf(210L, 155L, 4L, 2L),
    )

    val p3 = MarketUiState(
        day = 4, totalDays = 20, gold = 500, load = 16, capacity = 40,
        rows = prices.map { (id, p) ->
            GoodRow(id, p[0], p[1], selected = id == "cloth", stock = p[2].toInt(), owned = if (id == "cloth") 8 else 0, unitLoad = p[3].toInt())
        },
        detail = GoodDetail(
            goodId = "cloth", buyUnit = 35, sellUnit = 28, stock = 30, owned = 8, unitLoad = 2,
            sellBatch = BatchInfo("cloth-q100", 5, 100, 24, 4), otherBatchUnits = 3,
            batches = listOf(BatchInfo("cloth-q100", 5, 100, 24, 4), BatchInfo("cloth-q60", 3, 60, 20, -3)),
            quantity = 2, buyMax = 12, sellMax = 5,
            buy = TradePreview(70, 500, 430, 16, 20, emptyList()),
            sell = TradePreview(56, 500, 556, 16, 12, emptyList()),
        ),
    )
}
