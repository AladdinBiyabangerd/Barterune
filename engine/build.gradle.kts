plugins {
    alias(libs.plugins.kotlin.jvm)
    alias(libs.plugins.kotlin.serialization)
}
kotlin { jvmToolchain(21) }
// Pure JVM: no Android, UI, database or provider dependencies.
dependencies {
    api(project(":content"))
    implementation(libs.kotlinx.serialization.json)
    testImplementation(libs.junit4)
}
