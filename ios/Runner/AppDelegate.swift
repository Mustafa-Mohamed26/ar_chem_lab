import Flutter
import UIKit
import UnityFramework

@main
@objc class AppDelegate: FlutterAppDelegate, UnityFrameworkListener {

    var flutterChannel: FlutterMethodChannel?
    var ufw: UnityFramework?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        guard let controller = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }

        flutterChannel = FlutterMethodChannel(name: "com.ar_chem_lab/unity",
                                              binaryMessenger: controller.binaryMessenger)

        flutterChannel?.setMethodCallHandler { [weak self] call, result in
            if call.method == "launchUnity" {
                let args = call.arguments as? [String: Any]
                let sceneName = args?["scene_name"] as? String ?? "LoadingScene"
                
                self?.launchUnity(targetScene: sceneName)
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func launchUnity(targetScene: String) {
        let isInitialized = ufw != nil
        
        if !isInitialized {
            ufw = loadUnityFramework()
            ufw?.setDataBundleId("com.unity3d.framework")
            ufw?.register(self)
            ufw?.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: nil)
        } else {
            ufw?.showUnityWindow()
        }
        
        // Delay ensures Unity has fully instantiated the FlutterBridge GameObject
        DispatchQueue.main.asyncAfter(deadline: .now() + (isInitialized ? 0.3 : 1.5)) {
            self.ufw?.sendMessageToGO(withName: "FlutterBridge", functionName: "ReceiveSceneName", message: targetScene)
        }
    }

    private func loadUnityFramework() -> UnityFramework? {
        let bundlePath = Bundle.main.bundlePath + "/Frameworks/UnityFramework.framework"
        guard let bundle = Bundle(path: bundlePath) else { return nil }
        if !bundle.isLoaded {
            bundle.load()
        }
        return bundle.principalClass?.getInstance()
    }

    func unityDidUnload(_ notification: Notification!) {
        ufw?.unregisterFrameworkListener(self)
        ufw = nil
    }
}
