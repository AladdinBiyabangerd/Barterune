plugins { id("com.android.application"); kotlin("android"); id("org.jetbrains.kotlin.plugin.compose") }
android {
 namespace = "design.barterune.d2harness"
 compileSdk = 36
 defaultConfig { applicationId = "design.barterune.d2harness"; minSdk = 26; targetSdk = 34; versionCode = 1; versionName = "spike-1"; testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner" }
 buildFeatures { compose = true }
 compileOptions { sourceCompatibility = JavaVersion.VERSION_21; targetCompatibility = JavaVersion.VERSION_21 }
}
kotlin { jvmToolchain(21) }
androidComponents { beforeVariants(selector().withBuildType("release")) { it.enable = false } }
dependencyLocking { lockAllConfigurations() }
dependencies {
 implementation("androidx.activity:activity-compose:1.9.3")
 implementation("androidx.compose.foundation:foundation:1.7.6")
 implementation("androidx.compose.ui:ui:1.7.6")
 androidTestImplementation("androidx.compose.ui:ui-test-junit4:1.7.6")
 androidTestImplementation("androidx.test:runner:1.6.2")
 debugImplementation("androidx.compose.ui:ui-test-manifest:1.7.6")
}
