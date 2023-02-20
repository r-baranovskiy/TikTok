import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let rootVC = ViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}
