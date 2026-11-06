package barterune.feature.market.ui

import androidx.annotation.StringRes
import barterune.engine.command.RejectReason
import com.aladdin.barterune.feature.market.R

internal object MarketText {
    @StringRes fun goodName(goodId: String): Int = when (goodId) {
        "grain" -> R.string.good_grain
        "wood" -> R.string.good_wood
        "cloth" -> R.string.good_cloth
        "spices" -> R.string.good_spices
        "iron" -> R.string.good_iron
        "salt" -> R.string.good_salt
        "wool" -> R.string.good_wool
        "herbs" -> R.string.good_herbs
        "mana_crystal" -> R.string.good_mana_crystal
        "dragon_resin" -> R.string.good_dragon_resin
        else -> error("No name for $goodId")
    }

    @StringRes fun reason(reason: RejectReason): Int = when (reason) {
        RejectReason.OUT_OF_STOCK -> R.string.reason_out_of_stock
        RejectReason.NOT_ENOUGH_GOLD -> R.string.reason_gold
        RejectReason.NOT_ENOUGH_CAPACITY -> R.string.reason_capacity
        RejectReason.UNKNOWN_BATCH -> R.string.reason_no_batch
        RejectReason.NOT_ENOUGH_IN_BATCH -> R.string.reason_batch_quantity
        RejectReason.STALE_REVISION -> R.string.reason_stale
        RejectReason.INVALID_QUANTITY, RejectReason.UNKNOWN_GOOD, RejectReason.AMOUNT_OVERFLOW -> R.string.reason_quantity
    }

    fun signed(value: Long): String = if (value > 0) "+$value" else value.toString()
}
