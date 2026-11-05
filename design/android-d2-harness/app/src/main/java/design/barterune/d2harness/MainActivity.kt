package design.barterune.d2harness

import android.os.Bundle
import android.os.SystemClock
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.compose.BackHandler
import androidx.compose.foundation.*
import androidx.compose.foundation.interaction.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.*
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.*
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.*
import androidx.compose.ui.unit.*
import org.json.JSONObject

class MainActivity : ComponentActivity() {
    val journal = mutableListOf<String>()
    private fun record(action: String) {
        val entry = "${SystemClock.elapsedRealtime()}|v15-pay-guard-road|$action"
        journal.add(entry); Log.i("D2Harness", entry)
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent { Spike(intent.getStringExtra("state") ?: "confirm", intent.getStringExtra("language") ?: "AZ", ::record) }
    }
}

@Composable
fun Spike(initial: String, language: String, record: (String) -> Unit) {
    require(initial in listOf("confirm", "pending"))
    val context = LocalContext.current
    fun read(name: String) = JSONObject(context.assets.open(name).bufferedReader().use { it.readText() })
    val fixtures = remember { read("D2-payment-modes-v15-fixtures.json").getJSONArray("variants") }
    val translations = remember { read("D2-payment-localization-v15.json").getJSONObject("languages").getJSONObject(language) }
    val geo = remember { read("D1-pixel-composition-tokens.json").getJSONObject("geometry") }
    val roles = remember { read("D1-canonical-render-matrix.json").getJSONObject("typeTrial").getJSONObject("roles") }
    val colors = remember { read("D6-canonical-token-proposal.json").getJSONObject("referenceColors") }
    fun color(name: String) = Color(android.graphics.Color.parseColor(colors.getJSONObject(name).getString("value")))
    // Same density/2 mapping as the accepted static D2 renderer; harness only.
    fun dimension(name: String) = (geo.getDouble(name) / 2).dp
    val font = remember { FontFamily(Typeface(android.graphics.Typeface.Builder(context.assets, "NotoSans[wdth,wght].ttf").build())) }
    fun style(role: String): TextStyle {
        val v = roles.getJSONObject(role)
        return TextStyle(color = color("nav"), fontFamily = font, fontSize = v.getInt("sizeSp").sp,
            lineHeight = v.getInt("lineHeightSp").sp, fontWeight = FontWeight(v.getInt("weight")))
    }
    fun tr(s: String) = translations.getString(s)
    var state by remember { mutableStateOf(initial) }
    val fixture = (0 until fixtures.length()).map { fixtures.getJSONObject(it) }.first {
        it.getString("modeId") == "guard-road" && it.getString("paymentState") == state
    }
    val primaryFocus = remember { FocusRequester() }
    val backFocus = remember { FocusRequester() }
    var primaryFocused by remember { mutableStateOf(false) }
    val enabled = fixture.getBoolean("enabled")
    LaunchedEffect(enabled) { if (!enabled && primaryFocused) backFocus.requestFocus() }
    BackHandler { record("back") }
    val pad = dimension("inset")
    @Composable fun text(value: String, role: String, id: String, headingValue: Boolean = false) {
        BasicText(tr(value), style = style(role), modifier = Modifier.testTag(id).semantics { if (headingValue) heading() })
    }
    @Composable fun action(label: String, id: String, active: Boolean, requester: FocusRequester, onClick: () -> Unit) {
        val interactions = remember { MutableInteractionSource() }
        val focused by interactions.collectIsFocusedAsState()
        val pressed by interactions.collectIsPressedAsState()
        val invert = pressed
        val fill = if (invert) color("paper") else color("nav")
        val ink = if (invert) color("nav") else color("paper")
        val edge = dimension("frameEdge")
        var mod = Modifier.fillMaxWidth().heightIn(min = dimension("target")).testTag(id)
            .focusRequester(requester).onFocusChanged { if (id == "primary") primaryFocused = it.isFocused; record("focus:$id:${it.isFocused}") }
        mod = mod.drawBehind {
            val e = edge.toPx()
            drawRect(fill)
            if (focused) {
                drawRect(color("paper"))
                drawRect(color("nav"), Offset(e,e), Size(size.width-2*e,size.height-2*e))
                if (pressed) drawRect(color("paper"), Offset(2*e,2*e), Size(size.width-4*e,size.height-4*e))
            }
        }
        // Disabled has no click action but remains a named button in semantics.
        mod = mod.semantics {
            role = Role.Button
            if (!active) { disabled(); stateDescription = tr(fixture.getString("status")) + ". " + tr(fixture.getJSONArray("right").getString(3)) }
        }
        if (active) mod = mod.clickable(interactionSource = interactions, indication = null, role = Role.Button, onClick = onClick)
        BasicText(tr(label), style = style("label").copy(color = ink), modifier = mod.padding(pad))
    }
    Column(Modifier.fillMaxSize().background(color("paper")).safeDrawingPadding()
        .padding(dimension("margin")).verticalScroll(rememberScrollState()).semantics { isTraversalGroup = true },
        verticalArrangement = Arrangement.spacedBy(dimension("gap"))) {
        BasicText(tr(fixture.getString("title")), style = style("screenTitle"), modifier = Modifier.testTag("title").semantics { heading(); paneTitle = tr(fixture.getString("title")) })
        BasicText(tr(fixture.getString("status")), style = style("supporting"), modifier = Modifier.testTag("status").semantics { liveRegion = LiveRegionMode.Polite })
        for (side in listOf("left", "right")) {
            val rows = fixture.getJSONArray(side)
            for (i in 0 until rows.length()) text(rows.getString(i), if (i == 0) "sectionTitle" else "body", "$side-$i", i == 0)
        }
        action(fixture.getString("primary"), "primary", enabled, primaryFocus) { if (state == "confirm") { record("primary"); state = "pending" } }
        action("← Geri", "back", true, backFocus) { record("back") }
    }
}
