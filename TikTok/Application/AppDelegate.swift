import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.rootViewController = MainTabBarController()
        self.window = window
        self.window?.makeKeyAndVisible()
        FirebaseApp.configure()
        AuthManager.shared.signOut { _ in
            //
        }
        return true
    }
}

