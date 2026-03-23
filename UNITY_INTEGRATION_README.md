# Unity Native Integration Troubleshooting Guide

When integrating a Unity project natively ("Unity as a Library" or UaaL) into a modern Flutter application (using AGP 8.x and Kotlin DSL), you will frequently run into native build and configuration conflicts. 

If you ever need to rebuild the integration from scratch or update the `unityExport` folder, here is the complete checklist of all the fixes required to make it compile and run smoothly on Android.

---

### 1. `settings.gradle.kts` (Root)
You must explicitly declare both the standard library and any hidden nested AR modules (like `xrmanifest.androidlib`), and manually map their file paths.
```kotlin
include(":app")
include(":unityLibrary")
include(":unityLibrary:xrmanifest.androidlib")
project(":unityLibrary").projectDir = java.io.File("unityExport/unityLibrary")
project(":unityLibrary:xrmanifest.androidlib").projectDir = java.io.File("unityExport/unityLibrary/xrmanifest.androidlib")
```

### 2. `android/gradle.properties` (Root)
When Unity exports the project, it creates a custom `gradle.properties` inside the `unityExport` folder. Because Flutter only reads the root properties file, you **must** copy those missing Unity properties over to `android/gradle.properties`, otherwise Gradle will throw an `unknown property unityStreamingAssets` error.
```properties
# Add these at the bottom of android/gradle.properties
unityStreamingAssets=
unityTemplateVersion=7
```

### 3. `build.gradle.kts` (Root)
To resolve internal Unity `.aar` packages like `arcore_client` and `ARPresto`, your app needs to know where to find them. Add a `flatDir` routing to the unity lib folder inside `allprojects > repositories`:
```kotlin
allprojects {
    repositories {
        google()
        mavenCentral()
        flatDir {
            dirs("${rootProject.projectDir}/unityExport/unityLibrary/libs")
        }
    }
}
```

### 4. `app/build.gradle.kts` (App Level)
1. **Dependencies**: Add the unity module. Remember that in Kotlin DSL, `project().file()` doesn't resolve inside the dependencies block, so use a relative path string instead.
```kotlin
dependencies {
    implementation(project(":unityLibrary"))
    implementation(fileTree(mapOf("dir" to "../unityExport/unityLibrary/libs", "include" to listOf("*.jar"))))
}
```
2. **Min SDK**: Overwrite Flutter's default `minSdk = flutter.minSdkVersion` with `minSdk = 30`. Unity AR libraries enforce API 30+; keeping Flutter's default will cause a Manifest Merger failure.
3. **Kotlin JVM Error**: Modern AGP deprecates `kotlinOptions`. If you get a `jvmTarget` string error, delete the `kotlinOptions { jvmTarget = "17" }` block inside `android {}` and hoist this configuration to the top of the file:
```kotlin
kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}
```

### 5. Unity `build.gradle` Patches (inside `unityLibrary` and `xrmanifest`)
Modern Gradle (AGP 8.x) deprecated the `Sdk` syntax Unity historically exports.
In both `unityLibrary/build.gradle` and `xrmanifest.androidlib/build.gradle`, you must rename:
- `compileSdkVersion` -> `compileSdk`
- `minSdkVersion` -> `minSdk`
- `targetSdkVersion` -> `targetSdk`

Additionally, in `unityLibrary/build.gradle`, you must hardcode the NDK version to match the bundled Unity NDK path to avoid the `[CXX1100] android.ndkVersion mismatch` crash:
```groovy
android {
    namespace "com.unity3d.player"
    ndkPath "C:/Program Files/Unity/Hub/Editor/2022.3.62f3/Editor/Data/PlaybackEngines/AndroidPlayer/NDK"
    ndkVersion "23.1.7779620" // <--- Add this explicitly
}
```

### 6. App Manifest Merger (`AndroidManifest.xml`)
When defining `UnityPlayerActivity` in your app's manifest, Android will realize that `unityLibrary` also defines it with different attributes (like hardware acceleration and orientation). To force your App's rules, implement `tools:replace`:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools"> <!-- 1. Add tools namespace -->
    
    <application>
        <activity
            android:name="com.unity3d.player.UnityPlayerActivity"
            android:hardwareAccelerated="true"
            android:screenOrientation="landscape"
            tools:replace="android:hardwareAccelerated,android:screenOrientation" <!-- 2. Suppress overlaps -->
            android:exported="true" />
    </application>
</manifest>
```

### 7. The Fatal `Resources$NotFoundException #0x0` Crash (Strings.xml)
This is the most dangerous crash because it happens silently at runtime without halting the compiler.
Unity 2022/2023 explicitly tries to fetch an accessibility label (`game_view_content_description`) through the Android Native system when initializing the `UnityPlayer`.

If your Flutter project does not define this string, Unity crashes the entire app the second it opens.
Create or edit `android/app/src/main/res/values/strings.xml`:
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="game_view_content_description">Game view</string>
</resources>
```

---
*Follow these 7 steps precisely whenever upgrading Unity versions or generating fresh Unity exports into this Workspace.*
