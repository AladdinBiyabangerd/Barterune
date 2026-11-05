package barterune.core.designsystem.component

import androidx.annotation.DrawableRes
import androidx.compose.foundation.Image
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.FilterQuality
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.imageResource
import com.aladdin.barterune.core.designsystem.R

/** Nearest-neighbour pixel art; decorative unless [description] is set. */
@Composable
fun PixelArt(@DrawableRes id: Int, modifier: Modifier = Modifier, description: String? = null) {
    Image(
        bitmap = ImageBitmap.imageResource(id),
        contentDescription = description,
        contentScale = ContentScale.FillBounds,
        filterQuality = FilterQuality.None,
        modifier = modifier,
    )
}

/** Asset registry for goods; unknown ids have no art. */
object GoodArt {
    private val ids = mapOf(
        "grain" to R.drawable.good_grain,
        "wood" to R.drawable.good_wood,
        "cloth" to R.drawable.good_cloth,
        "spices" to R.drawable.good_spices,
        "iron" to R.drawable.good_iron,
        "salt" to R.drawable.good_salt,
        "wool" to R.drawable.good_wool,
        "herbs" to R.drawable.good_herbs,
        "mana_crystal" to R.drawable.good_mana_crystal,
        "dragon_resin" to R.drawable.good_dragon_resin,
    )

    @DrawableRes fun of(goodId: String): Int? = ids[goodId]

    @DrawableRes val MarketPanorama: Int = R.drawable.market_panorama
}
