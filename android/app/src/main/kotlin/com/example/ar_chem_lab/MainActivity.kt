package com.example.ar_chem_lab

import android.content.Intent
import android.os.Handler
import android.os.Looper
import com.unity3d.player.UnityPlayer
import com.unity3d.player.UnityPlayerActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.ar_chem_lab/unity"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "launchUnity") {
                val targetScene = call.argument<String>("scene_name") ?: "LoadingScene"
                val userName = call.argument<String>("user_name") ?: "Alchemist"
                
                // Launch the Unity Library natively
                val intent = Intent(this, OverrideUnityActivity::class.java)
                intent.putExtra("TARGET_SCENE", targetScene) // Pass the scene name here
                intent.putExtra("TARGET_USER_NAME", userName) // Pass the user name here
                intent.flags = Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or Intent.FLAG_ACTIVITY_NEW_TASK
                startActivity(intent)
                
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
