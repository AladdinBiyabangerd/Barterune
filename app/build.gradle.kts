plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.compose)
}

// Firebase (Spark only): config lives outside the module and is never committed.
// The google-services plugin is applied only when that file exists; it is copied in as a gitignored build input.
val firebaseConfig = rootProject.file("config/firebase/google-services.json")
if (firebaseConfig.exists()) {
    firebaseConfig.copyTo(file("google-services.json"), overwrite = true)
    apply(plugin = libs.plugins.google.services.get().pluginId)
}

android {
    namespace = "com.aladdin.barterune"
    compileSdk = 36
    defaultConfig {
        applicationId = "com.aladdin.barterune"
        // Product minSdk is still open (DT09); 24 mirrors Arrowz for the local M1 prototype.
        minSdk = 24
        targetSdk = 36
        versionCode = 1
        versionName = "0.1.0-m1"
    }
    buildTypes {
        release { isMinifyEnabled = false }
    }
    compileOptions { sourceCompatibility = JavaVersion.VERSION_21; targetCompatibility = JavaVersion.VERSION_21 }
    buildFeatures { compose = true }
}
kotlin { jvmToolchain(21) }
dependencies {
    implementation(project(":core:designsystem"))
    implementation(project(":core:database"))
    implementation(project(":core:data"))
    implementation(project(":feature:market"))
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.activity.compose)
    implementation(libs.androidx.lifecycle.viewmodel.compose)
    implementation(libs.kotlinx.coroutines.android)
}
