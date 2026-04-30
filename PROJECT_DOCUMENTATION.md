# AR Chem Lab - Comprehensive Technical Documentation

## 1. Executive Summary

**AR Chem Lab** is a high-performance educational application that integrates the Flutter framework with the Unity Engine to provide an immersive Augmented Reality (AR) chemistry experience. The project is built using **Clean Architecture** and **BLoC** state management, ensuring a scalable and maintainable codebase.

---

## 2. Architecture & File Structure

### 2.1 Project Layers

The `lib/` directory follows a strict layered architecture:

| Layer            | Directory           | Responsibility                                                           |
| :--------------- | :------------------ | :----------------------------------------------------------------------- |
| **Presentation** | `lib/presentation/` | UI Screens, BLoC logic, and feature-specific widgets.                    |
| **Domain**       | `lib/domain/`       | Pure business logic, Entities, Use Cases, and Repository Interfaces.     |
| **Data**         | `lib/data/`         | Implementation of repositories, API clients (Dio), and Models.           |
| **Core**         | `lib/core/`         | Cross-cutting concerns: Services, Utilities, routes, and error handling. |

### 2.2 Key Services

- **`AppInitializationService`**: Coordinates startup logic (DI, ScreenUtil initialization).
- **`InitialRouteResolver`**: Logic for determining the first screen (Auth check, Onboarding status).
- **`ArUnityService`**: Manages the MethodChannel communication for launching Unity.

---

## 3. Unity Native Integration (Android)

Unity is embedded as a native Android Library (`unityLibrary`). The integration is optimized for **AGP 8.x** and **Kotlin DSL**.

### 3.1 Integration Checklist (Re-exporting Unity)

Follow these 7 steps whenever you generate a fresh Unity export into `android/unityExport/`:

1.  **`settings.gradle.kts`**: Manually include the `:unityLibrary` and `:unityLibrary:xrmanifest.androidlib` modules.
2.  **`gradle.properties`**: Add `unityStreamingAssets=` and `unityTemplateVersion=7` to the root project.
3.  **FlatDir Routing**: In the root `build.gradle.kts`, add the Unity `libs` folder to the repository list to resolve internal `.aar` files.
4.  **Min SDK Sync**: Ensure `minSdk` is set to **30** in `app/build.gradle.kts` (Unity AR Core requirement).
5.  **NDK Pinning**: Hardcode `ndkVersion "23.1.7779620"` in `unityLibrary/build.gradle` to match Unity's toolchain.
6.  **Manifest Merger**: Use `tools:replace` for `android:hardwareAccelerated` and `android:screenOrientation` in the `UnityPlayerActivity` declaration.
7.  **Strings.xml Fix**: Ensure `game_view_content_description` is defined in `res/values/strings.xml` to prevent the silent `Resources$NotFoundException` crash.

### 3.2 The "Return to Flutter" Solution (Process Isolation)

**Problem**: Unity kills the entire app process when exiting (`System.exit(0)`).
**Solution**:

- **Isolated Process**: Unity runs in a dedicated `:unityplayer` process.
- **`OverrideUnityActivity`**: A custom Kotlin class subclasses `UnityPlayerActivity`, allowing the Unity process to shut down without affecting the main Flutter process.
- **Intent Bridge**: Since memory cannot be shared across processes, the `TARGET_SCENE` name is passed as an **Intent Extra** and dispatched from within the Unity process.

---

## 4. Comprehensive Feature Analysis

### 4.1 AR Chemistry Laboratory (Unity Core)

The crown jewel of the application. It allows students to perform virtual experiments that would be dangerous or expensive in real life.

- **Scene-Based Navigation**: Flutter passes specific experiment IDs to Unity to trigger the correct AR scene.
- **Native Stability**: Uses the `:unityplayer` process isolation to ensure 100% uptime for the Flutter host app.
- **Experiment Variety**: Supports chemical reaction simulations, atomic structure visualization, and safety training.

### 4.2 Interactive Periodic Table

A highly detailed exploration tool for the building blocks of chemistry.

- **3D Atomic Models**: Integrated `model_viewer_plus` allows users to view 3D Bohr models of every element.
- **Rich Metadata**: Provides atomic weight, electronegativity, configuration, and historical data for all 118 elements.
- **Dynamic Filtering**: Users can filter elements by category (Alkali metals, Noble gases, etc.).

### 4.3 AI Science Assistant (ChatBot)

A generative AI-powered tutor that assists students with their chemistry homework and lab prep.

- **Contextual Awareness**: The AI is tuned for scientific accuracy and chemical safety.
- **Polished UI**: Features thinking indicators (`ThinkingDots`) and a smooth `TypewriterText` effect for realistic conversation.
- **Markdown Support**: Correctly renders chemical formulas (e.g., H₂O, H₂SO₄) using `flutter_markdown`.

### 4.4 Authentication & Progressive Profiling

A secure gateway that personalizes the educational experience.

- **JWT Security**: Uses token-based authentication for persistent sessions.
- **Educational Tiering**: During profiling, users choose their educational level (Grade/University), which filters the difficulty of the AR experiments.
- **Secure Storage**: Sensitive tokens are stored using encrypted shared preferences.

### 4.5 Onboarding & Progress Tracking

- **Interactive Onboarding**: A high-fidelity introduction using smooth animations to guide new users.
- **Experiment History**: Tracks which labs the user has completed, allowing them to resume their learning path.

---

## 5. Maintenance & Troubleshooting

### Building the Project

1.  Run `flutter clean` to clear stale native caches.
2.  Run `dart run build_runner build` to regenerate Dependency Injection code.
3.  Use `flutter run` for standard testing or `flutter build apk --debug` for native stabilization verification.

---

## 6. Native Source Code Reference

### 6.1 `OverrideUnityActivity.kt`

This class ensures Unity runs in an isolated process and handles the scene-loading message internally.

```kotlin
package com.example.ar_chem_lab

import com.unity3d.player.UnityPlayerActivity
import android.os.Bundle

class OverrideUnityActivity : UnityPlayerActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Get the target scene name from the intent
        val targetScene = intent.getStringExtra("TARGET_SCENE")

        if (targetScene != null) {
            // Since this activity is in the :unityplayer process, we can send messages directly
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                com.unity3d.player.UnityPlayer.UnitySendMessage("FlutterBridge", "ReceiveSceneName", targetScene)
            }, 1500)
        }
    }

    override fun finish() {
        // Simply finish the activity, which will now safely only close the Unity process
        super.finish()
    }
}
```

### 6.2 `MainActivity.kt` (Launch Logic)

Handles the MethodChannel and initiates the isolated Unity process.

```kotlin
MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
if (call.method == "launchUnity") {
    val targetScene = call.argument<String>("scene_name") ?: "LoadingScene"

        // Launch the Unity Library natively using the custom activity
    val intent = Intent(this, OverrideUnityActivity::class.java)
    intent.putExtra("TARGET_SCENE", targetScene)
    intent.flags = Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or Intent.FLAG_ACTIVITY_NEW_TASK
    startActivity(intent)

    result.success(null)
}
}
```

### 6.3 `AndroidManifest.xml` (Key Additions)

Required for Camera permissions and Process Isolation.

```xml
<!-- 1. Permissions & Features -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera.ar" android:required="true" />

<!-- 2. Activity Isolation -->
<activity
    android:name=".OverrideUnityActivity"
    android:theme="@style/UnityThemeSelector"
    android:process=":unityplayer"
    tools:replace="android:hardwareAccelerated,android:screenOrientation"
    android:exported="true" />
```

---

_Documentation last updated on 2026-04-29_
