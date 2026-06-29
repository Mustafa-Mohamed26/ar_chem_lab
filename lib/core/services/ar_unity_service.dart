import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class ARUnityService {
  static const MethodChannel _channel = MethodChannel('com.ar_chem_lab/unity');

  static Future<void> launchUnity(String targetScene, String username) async {
    try {
      debugPrint('Initializing Unity with Target Scene: $targetScene for user: $username');
      await _channel.invokeMethod('launchUnity', {
        'scene_name': targetScene,
        'user_name': username,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to launch Unity AR: ${e.message}');
    }
  }
}
