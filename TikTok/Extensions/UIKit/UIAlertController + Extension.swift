import UIKit

extension UIAlertController {
    static func createErrorWarning(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Woops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        return alert
    }
}
