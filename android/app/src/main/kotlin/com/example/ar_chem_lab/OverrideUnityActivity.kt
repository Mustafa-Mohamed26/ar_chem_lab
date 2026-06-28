package com.example.ar_chem_lab

import com.unity3d.player.UnityPlayerActivity
import android.os.Bundle

class OverrideUnityActivity : UnityPlayerActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Get the target scene name from the intent
        val targetScene = intent.getStringExtra("TARGET_SCENE")
        val targetUserName = intent.getStringExtra("TARGET_USER_NAME")
        
        if (targetScene != null) {
            // Since this activity is in the :unityplayer process, we can send messages directly
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                com.unity3d.player.UnityPlayer.UnitySendMessage("FlutterBridge", "ReceiveSceneName", targetScene)
                if (targetUserName != null) {
                    com.unity3d.player.UnityPlayer.UnitySendMessage("FlutterBridge", "SetUserData", targetUserName)
                }
            }, 1500)
        }
    }

    override fun finish() {
        // Simply finish the activity, which will now safely only close the Unity process
        super.finish()
    }
}
