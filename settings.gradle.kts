pluginManagement { repositories { google(); mavenCentral(); gradlePluginPortal() } }
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories { google(); mavenCentral() }
}
rootProject.name = "barterune"

// android-billing stays an isolated build (barterune-billing); host integration is M5.
include(
    ":app",
    ":engine",
    ":content",
    ":core:designsystem",
    ":core:database",
    ":core:data",
    ":feature:market",
)
