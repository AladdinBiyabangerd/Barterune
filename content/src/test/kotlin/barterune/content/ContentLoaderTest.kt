package barterune.content

import org.junit.Assert.assertEquals
import org.junit.Test

class ContentLoaderTest {
    @Test
    fun classicPackMatchesAcceptedBalanceB01B02() {
        val pack = ContentLoader.loadClassic()
        assertEquals(300L, pack.start.gold)
        assertEquals(30, pack.start.capacity)
        assertEquals("sunbulova", pack.start.cityId)
        assertEquals(10, pack.goods.size)
        assertEquals(4, pack.cities.size)
        assertEquals(CityRole.PRODUCER, pack.city("sunbulova").roleOf("grain"))
        assertEquals(CityRole.HIGH_DEMAND, pack.city("sunbulova").roleOf("cloth"))
        assertEquals(CityRole.NEUTRAL, pack.city("sunbulova").roleOf("iron"))
    }

    @Test(expected = IllegalArgumentException::class)
    fun rejectsUnknownStartCity() {
        val text = ContentLoader::class.java.classLoader.getResource(ContentLoader.CLASSIC_V1)!!.readText()
        ContentLoader.parse(text.replace("\"cityId\": \"sunbulova\"", "\"cityId\": \"nowhere\""))
    }
}
