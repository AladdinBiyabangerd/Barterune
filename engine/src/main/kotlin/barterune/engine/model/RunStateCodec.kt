package barterune.engine.model

import kotlinx.serialization.json.Json

/** Versioned save payload codec. */
object RunStateCodec {
    const val SCHEMA_VERSION = 1
    private val json = Json { encodeDefaults = true }
    fun encode(state: RunState): String = json.encodeToString(RunState.serializer(), state)
    fun decode(text: String): RunState = json.decodeFromString(RunState.serializer(), text)
}
