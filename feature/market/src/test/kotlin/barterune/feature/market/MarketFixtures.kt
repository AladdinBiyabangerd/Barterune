package barterune.feature.market

/** D1-render-fixture.json base state (T01/T02) as drawn by D1-P3-master-detail.png. */
object MarketFixtures {
    private val prices = listOf(
        "grain" to (12L to 9L), "wood" to (20L to 15L), "cloth" to (35L to 28L), "spices" to (60L to 45L),
        "iron" to (48L to 36L), "salt" to (10L to 7L), "wool" to (24L to 18L), "herbs" to (32L to 23L),
        "mana_crystal" to (150L to 110L), "dragon_resin" to (210L to 155L),
    )

    val p3 = MarketUiState(
        day = 4, totalDays = 20, gold = 500, load = 16, capacity = 40,
        rows = prices.map { (id, p) -> GoodRow(id, p.first, p.second, selected = id == "cloth") },
        detail = GoodDetail(
            goodId = "cloth", buyUnit = 35, sellUnit = 28, stock = 30, owned = 8, unitLoad = 2,
            sellBatch = BatchInfo("cloth-q100", 5, 100, 24, 4), otherBatchUnits = 3,
            quantity = 2, buyMax = 12, sellMax = 5,
            buy = TradePreview(70, 500, 430, 16, 20, emptyList()),
            sell = TradePreview(56, 500, 556, 16, 12, emptyList()),
        ),
    )
}
