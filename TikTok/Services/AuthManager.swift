import Foundation
import FirebaseAuth

final class AuthManager {
    
    public static let shared = AuthManager()
        
    private init() {}
    
    enum SignInMethod {
        case email
        case google
    }
    
    // Public
    
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut() {
        
    }
}
