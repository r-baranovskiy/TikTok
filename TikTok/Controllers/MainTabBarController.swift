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
            title: nil, image: UIImage(systemName: "camera"), tag: 3)
        
        viewControllers = [
            createNavigationVC(title: "Home", rootVC: homeVC,
                               imageSystemName: "house"),
            createNavigationVC(title: "Explore", rootVC: exploreVC,
                               imageSystemName: "safari"),
            cameraVC,
            createNavigationVC(title: "Notifications", rootVC: notificationsVC,
                               imageSystemName: "bell"),
            createNavigationVC(title: "Profile", rootVC: profileVC,
                               imageSystemName: "person.circle")
        ]
    }
    
    private func createNavigationVC(
        title: String, rootVC: UIViewController, imageSystemName: String) -> UINavigationController {
            let navVC = UINavigationController(rootViewController: rootVC)
            rootVC.title = title
            navVC.tabBarItem.image = UIImage(
                systemName: imageSystemName, withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))
            return navVC
        }
}
