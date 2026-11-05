package barterune.feature.market.ui

import androidx.compose.ui.unit.dp

/**
 * Composition values of D1-P3-master-detail that are not shared tokens yet, read from
 * design/tools/render-design-suite-v15.swift (2 px = 1 dp). Kept local until D6 names them.
 */
internal object MarketLayout {
    /** control("Al 70", width: 500 px). */
    val TradeActionWidth = 250.dp
    /** Actions at y = 1400 px on a 1600 px board with frames ending at 1552 px: 1552 − 1496 = 56 px. */
    val TradeActionBottomInset = 28.dp
}
