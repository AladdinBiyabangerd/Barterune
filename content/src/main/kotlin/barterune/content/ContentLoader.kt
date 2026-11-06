package barterune.content

import kotlinx.serialization.json.Json

/** Reads bundled content JSON from the classpath; no Android dependency. */
object ContentLoader {
    const val CLASSIC_V1 = "content/classic-v1.json"

    private val json = Json { ignoreUnknownKeys = false }

    fun parse(text: String): ContentPack = json.decodeFromString(ContentPack.serializer(), text).also(::validate)

    fun loadClassic(): ContentPack {
        val stream = requireNotNull(ContentLoader::class.java.classLoader.getResourceAsStream(CLASSIC_V1)) {
            "Missing $CLASSIC_V1"
        }
        return parse(stream.bufferedReader(Charsets.UTF_8).use { it.readText() })
    }

    private fun validate(pack: ContentPack) {
        val goodIds = pack.goods.map { it.id }
        require(goodIds.toSet().size == goodIds.size) { "Duplicate good id" }
        require(pack.cities.any { it.id == pack.start.cityId }) { "Unknown start city" }
        pack.cities.forEach { city ->
            (city.produces + city.highDemand).forEach { require(it in goodIds) { "Unknown good $it in ${city.id}" } }
        }
        pack.goods.forEach { require(it.basePrice > 0 && it.unitLoad > 0 && it.normalStock >= 0) { "Bad good ${it.id}" } }
    }
}
