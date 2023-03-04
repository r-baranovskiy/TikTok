import UIKit

/// Root tab bar controller
final class MainTabBarController: UITabBarController {
    
    private var signInPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented {
            presentSignInIfNeeded()
        }
    }
    
    private func presentSignInIfNeeded() {
        if !AuthManager.shared.isSignedIn {
            signInPresented = true
            let vc = SignInViewController()
            vc.completion = { [weak self] in
                self?.signInPresented = false
            }
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            navVC.navigationBar.tintColor = .label
            present(navVC, animated: false)
        }
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
            rootVC: ProfileViewController(
                user: User(username: "kek", profilePictureURL: nil,
                           identifier: UUID().uuidString)),
            imageSystemName: "person.circle")
        
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
        
        tabBar.backgroundColor = .systemBackground
    }
    
    private func createNavigationVC(rootVC: UIViewController, imageSystemName: String) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.tabBarItem.image = UIImage(
            systemName: imageSystemName, withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))
        return navVC
    }
}
