import UIKit

final class SignInViewController: UIViewController {
    
    public var completion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
    }
}
