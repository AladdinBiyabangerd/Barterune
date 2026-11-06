package barterune.feature.market.ui

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.selected
import androidx.compose.ui.semantics.semantics
import barterune.core.designsystem.component.GoodArt
import barterune.core.designsystem.component.PixelArt
import barterune.core.designsystem.token.BarteruneColors
import barterune.core.designsystem.token.BarteruneSpacing
import barterune.core.designsystem.token.BarteruneTypography
import barterune.feature.market.GoodRow
import com.aladdin.barterune.feature.market.R

/** Left master list (P3): icon, name with ✓ for the selection, "Al · Sat" line. */
@Composable
internal fun GoodList(rows: List<GoodRow>, onSelect: (String) -> Unit, modifier: Modifier = Modifier) {
    LazyColumn(
        modifier = modifier,
        contentPadding = PaddingValues(top = BarteruneSpacing.Inset, bottom = BarteruneSpacing.Inset),
        verticalArrangement = Arrangement.spacedBy(BarteruneSpacing.Gap),
    ) {
        items(rows, key = { it.goodId }) { row -> GoodListRow(row, onSelect) }
    }
}

@Composable
private fun GoodListRow(row: GoodRow, onSelect: (String) -> Unit) {
    val name = stringResource(MarketText.goodName(row.goodId))
    val text = BarteruneTypography.Label.copy(color = BarteruneColors.TextPrimary)
    Row(
        Modifier
            .fillMaxWidth()
            .height(BarteruneSpacing.Target)
            .semantics { selected = row.selected }
            .clickable(role = Role.Tab) { onSelect(row.goodId) }
            .padding(start = BarteruneSpacing.Margin),
    ) {
        GoodArt.of(row.goodId)?.let {
            PixelArt(it, Modifier.size(width = BarteruneSpacing.Target, height = BarteruneSpacing.Target - BarteruneSpacing.Inset))
        }
        Spacer(Modifier.width(BarteruneSpacing.Inset))
        Column {
            BasicText(if (row.selected) stringResource(R.string.market_selected_prefix, name) else name, style = text, maxLines = 1)
            BasicText(
                stringResource(R.string.market_row_prices, row.buyUnit, row.sellUnit),
                style = BarteruneTypography.Numeric.copy(color = BarteruneColors.TextPrimary),
                maxLines = 1,
            )
        }
    }
}
