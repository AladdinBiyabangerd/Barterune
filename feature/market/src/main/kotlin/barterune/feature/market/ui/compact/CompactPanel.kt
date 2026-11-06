package barterune.feature.market.ui.compact

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyListState
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clipToBounds
import androidx.compose.ui.semantics.Role
import barterune.core.designsystem.component.ParchmentPanel
import barterune.core.designsystem.component.PixelArt
import barterune.core.designsystem.token.BarteruneColors
import barterune.core.designsystem.token.BarteruneSpacing

/** Framed, scrolling list of [CompactRow] blocks (v7: rows inset by `inset`, separated by `gap`). */
@Composable
internal fun CompactPanel(
    rows: List<CompactRow>,
    modifier: Modifier = Modifier,
    listState: LazyListState = rememberLazyListState(),
) {
    ParchmentPanel(modifier) {
        LazyColumn(
            state = listState,
            modifier = Modifier.fillMaxSize().padding(BarteruneSpacing.Inset).clipToBounds(),
            contentPadding = PaddingValues(top = BarteruneSpacing.Inset, bottom = BarteruneSpacing.Inset),
            verticalArrangement = Arrangement.spacedBy(BarteruneSpacing.Gap),
        ) {
            items(rows) { row -> Block(row, Modifier.fillMaxWidth()) }
        }
    }
}

@Composable
private fun Block(row: CompactRow, modifier: Modifier) {
    val pair = row.pair
    if (pair == null) {
        Cell(row, modifier)
    } else {
        Row(modifier, horizontalArrangement = Arrangement.spacedBy(BarteruneSpacing.Gap)) {
            Cell(row, Modifier.weight(1f))
            Cell(pair, Modifier.weight(1f))
        }
    }
}

@Composable
private fun Cell(row: CompactRow, modifier: Modifier) {
    val action = row.onClick != null
    val filled = action && row.enabled
    var m = modifier.fillMaxWidth()
    if (action) m = m.heightIn(min = BarteruneSpacing.Target)
    if (filled) m = m.background(BarteruneColors.ActionFill).clickable(role = Role.Button, onClick = row.onClick!!)
    Box(m) {
        row.icon?.let { PixelArt(it, Modifier.width(BarteruneSpacing.Target).height(CompactLayout.IconHeight)) }
        BasicText(
            text = row.text,
            style = row.style.copy(color = if (filled) BarteruneColors.OnAction else BarteruneColors.TextPrimary),
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(
                    start = BarteruneSpacing.Inset + if (row.icon != null) BarteruneSpacing.Target else BarteruneSpacing.Inset * 0,
                    top = BarteruneSpacing.Inset / 2,
                    end = BarteruneSpacing.Inset,
                    bottom = BarteruneSpacing.Inset / 2,
                ),
        )
    }
}
