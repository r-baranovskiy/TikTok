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
    
    public func signUp(with username: String, _ email: String, _ password: String,
                       completion: @escaping (Bool) -> Void) {
        
    }
    
    public func signIn(with email: String, _ password: String,
                       completion: @escaping (Bool) -> Void) {
        
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
