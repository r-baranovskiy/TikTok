import UIKit

/// Root tab bar controller
final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureMainTabBar()
    }
    
    private func configureMainTabBar() {
        let homeNavVC = createNavigationVC(
            rootVC: HomeViewController(), imageSystemName: "house")
        let exploreNavVC = createNavigationVC(
            rootVC: ExploreViewController(), imageSystemName: "safari")
        let cameraVC = CameraViewController()
        let notificationsNavVC = createNavigationVC(
            rootVC: NotificationsViewController(), imageSystemName: "bell")
        let profileNavVC = createNavigationVC(
            rootVC: ProfileViewController(), imageSystemName: "person.circle")
        
        cameraVC.tabBarItem = UITabBarItem(
            title: nil, image: UIImage(
                systemName: "camera",
                withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)),
            tag: 3)
        
        homeNavVC.navigationBar.backgroundColor = .clear
        homeNavVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        homeNavVC.navigationBar.shadowImage = UIImage()
        
        viewControllers = [
            homeNavVC, exploreNavVC, cameraVC, notificationsNavVC, profileNavVC
        ]
    }
    
    private func createNavigationVC(rootVC: UIViewController, imageSystemName: String) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.tabBarItem.image = UIImage(
            systemName: imageSystemName, withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))
        return navVC
    }
}
