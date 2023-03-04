import UIKit

final class AuthTextField: UITextField {
    
    enum FieldType {
        case email
        case password
        case username
        
        var title: String {
            switch self {
            case .email:
                return "Email address"
            case .password:
                return "Password"
            case .username:
                return "Username"
            }
        }
    }
    
    private let type: FieldType
    
    init(type: FieldType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        autocorrectionType = .no
        autocapitalizationType = .none
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        returnKeyType = .done
        
        if type == .password {
            isSecureTextEntry = true
        } else if type == .email {
            keyboardType = .emailAddress
            textContentType = .emailAddress
        }
    }
}
