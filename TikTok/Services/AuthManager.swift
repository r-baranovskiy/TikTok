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
    
    enum AuthError: Error {
        case signInFailed
    }
    
    // Public
    
    public func signUp(with username: String, _ email: String, _ password: String,
                       completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            
            DatabaseManager.shared.insertUser(with: email, username: username,
                                              completion: completion)
        }
    }
    
    public func signIn(with email: String, _ password: String,
                       completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(AuthError.signInFailed))
                }
                return
            }
            
            completion(.success(email))
        }
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
