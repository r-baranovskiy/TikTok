import Foundation
import FirebaseAuth

final class AuthManager {
    
    public static let shared = AuthManager()
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
        
    private init() {}
    
    enum SignInMethod {
        case email
        case google
    }
    
    // Public
    
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
        }
    }
}
