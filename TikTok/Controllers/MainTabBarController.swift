import UIKit

/// Root tab bar controller
final class MainTabBarController: UITabBarController {
    
    private let homeVC = HomeViewController()
    private let exploreVC = ExploreViewController()
    private let cameraVC = CameraViewController()
    private let notificationsVC = NotificationsViewController()
    private let profileVC = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureMainTabBar()
    }
    
    private func configureMainTabBar() {
        cameraVC.tabBarItem = UITabBarItem(
            title: nil, image: UIImage(systemName: "camera", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)), tag: 3)
        
        viewControllers = [
            createNavigationVC(rootVC: homeVC, imageSystemName: "house"),
            createNavigationVC(rootVC: exploreVC, imageSystemName: "safari"),
            cameraVC,
            createNavigationVC(rootVC: notificationsVC, imageSystemName: "bell"),
            createNavigationVC(rootVC: profileVC, imageSystemName: "person.circle")
        ]
    }
    
    private func createNavigationVC(rootVC: UIViewController, imageSystemName: String) -> UINavigationController {
            let navVC = UINavigationController(rootViewController: rootVC)
            navVC.tabBarItem.image = UIImage(
                systemName: imageSystemName, withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))
            return navVC
        }
}
