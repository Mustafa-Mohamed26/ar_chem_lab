# Flutter-Unity Integration Technical Documentation

This document outlines the critical fixes and architectural improvements made to the **AR Chem Lab** project to ensure a stable, production-ready integration between Flutter and Unity.

---

## 1. Build System Stabilization

### NDK Version Mismatch Fix
Unity 2022.3 is tightly coupled with a specific NDK version. We encountered a `[CXX1100]` error because Gradle was attempting to use a newer NDK (version 27) while Unity's IL2CPP compiler required version 23.
- **Solution**: Explicitly pinned `ndkVersion "23.1.7779620"` in `android/unityExport/unityLibrary/build.gradle`.
- **Outcome**: The `BuildIl2CppTask` now correctly locates the toolchain and compiles the native code.

### IL2CPP Build Safety
The build was failing when the `libil2cpp.dbg.so` (debug symbols) file was missing—a common occurrence in certain Unity build configurations.
- **Solution**: Wrapped the `ant.move` command in a Groovy existence check:
  ```gradle
  if (file(workingDir + "/src/main/jniLibs/" + abi + "/libil2cpp.dbg.so").exists()) {
      ant.move(...)
  }
  ```
- **Outcome**: Builds no longer fail if Unity skips generating optional debug files.

---

## 2. Android Manifest & Permissions

### Duplicate App Icon Resolution
Integrating Unity often results in two icons appearing on the phone—one for the main app and one for Unity.
- **Solution**: Removed the `<intent-filter>` containing the `LAUNCHER` category from `unityLibrary/src/main/AndroidManifest.xml`.
- **Outcome**: The app now has a single, professional entry point through Flutter's `MainActivity`.

### AR Camera Permissions
Ensured the app correctly requests and declares the necessary hardware for Augmented Reality.
- **Solution**: Updated both `app` and `unityLibrary` manifests to include:
  - `android.permission.CAMERA`
  - `android.hardware.camera.ar` (Required for ARCore)
  - `com.google.ar.core.depth` (Required for AR occlusion)

---

## 3. Returning from Unity to Flutter (The "Return Fix")

The most difficult challenge in Unity-Flutter integration is returning to the Flutter UI without closing the whole app. 

### The Problem: Process Termination
By default, Unity's `UnityPlayerActivity` is designed to be the "Main" part of an app. When it closes, it calls `System.exit(0)`, which kills the entire Android process. If Flutter and Unity are in the same process, Flutter dies when Unity closes.

### The Solution: Process Isolation & Custom Exit
We implemented a two-part solution:
1.  **Process Isolation**: In the `AndroidManifest.xml`, we added `android:process=":unityplayer"` to the Unity Activity. This puts Unity in a "sandbox" process.
2.  **Custom Activity**: We created `OverrideUnityActivity.kt` which subclasses `UnityPlayerActivity`. This gives us a safe place to handle the `finish()` command.

### How to Implement the "Back" Button in Unity
To return to Flutter, attach this C# method to a button in your Unity scene:

```csharp
public void BackToFlutterApp()
{
    // Important: Only run this on Android devices
    if (Application.platform == RuntimePlatform.Android)
    {
        // 1. Get the UnityPlayer class
        AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");

        // 2. Get the current activity (which is our OverrideUnityActivity)
        AndroidJavaObject currentActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");

        // 3. Call finish() to close the Unity process and return to Flutter
        currentActivity.Call("finish");
    }
    else
    {
        // For testing in the Unity Editor
        Debug.Log("Back button pressed (Editor Mode)");
    }
}
```

### Why this works:
When `currentActivity.Call("finish")` is triggered:
- The isolated `:unityplayer` process shuts down.
- The Android OS automatically brings the previous activity (your Flutter `MainActivity`) to the front.
- Because Flutter is in the **Main Process**, it remains untouched and ready for the user.

---

## 4. Cross-Process Communication

Because Unity and Flutter now live in different processes, they can no longer share memory directly via standard `UnitySendMessage` calls from the `MainActivity`.

### Data Passing via Intent Extras
- **Flutter to Unity**: The target scene name is passed as an `Intent` extra from `MainActivity` to `OverrideUnityActivity`.
- **Activation**: Inside `OverrideUnityActivity.onCreate`, the scene name is extracted and delivered to Unity using `UnitySendMessage`. Since the activity and Unity are in the same isolated process, this communication is successful.

### Code Pattern for Returning:
In your Unity C# script, use this method to go back:
```csharp
public void BackToFlutterApp() {
    if (Application.platform == RuntimePlatform.Android) {
        AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
        AndroidJavaObject currentActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
        currentActivity.Call("finish"); 
    }
}
```

---

## 5. Maintenance Checklist
- **Updating Unity**: If you re-export Unity, you must ensure `build.gradle` retains the `ndkVersion` and `libil2cpp` file checks.
- **Manifest Merging**: Always check that `android:process=":unityplayer"` is preserved in the main app manifest.
- **Building**: Use `flutter clean` before major builds to ensure the isolated process mapping is correctly registered by the OS.
