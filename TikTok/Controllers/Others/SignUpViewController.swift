import UIKit
import SafariServices

final class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI Constants
    
    public var completion: (() -> Void)?
    
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.image = UIImage(named: "logoTikTok")
        return view
    }()
    
    private let emailTextField = AuthTextField(type: .email)
    private let passwordTextField = AuthTextField(type: .password)
    private let usernameTextField = AuthTextField(type: .username)
    
    private let signUpButton = AuthButton(type: .signUp)
    private let termsButton = AuthButton(type: .plain, title: "Terms of Service")
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Create Account"
        addSubview()
        configureButtons()
        configureTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpSizes()
    }
    
    // MARK: - Appearance
    
    private func addSubview() {
        view.addSubview(logoImageView)
        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(termsButton)
    }
    
    private func setUpSizes() {
        let imageSize: CGFloat = 100
        logoImageView.frame = CGRect(
            x: (view.width - imageSize) / 2, y: view.safeAreaInsets.top + 5,
            width: imageSize, height: imageSize)
        
        usernameTextField.frame = CGRect(
            x: 20, y: logoImageView.bottom + 20,
            width: view.width - 40, height: 55)
        
        emailTextField.frame = CGRect(
            x: 20, y: usernameTextField.bottom + 15,
            width: view.width - 40, height: 55)
        
        passwordTextField.frame = CGRect(
            x: 20, y: emailTextField.bottom + 15,
            width: view.width - 40, height: 55)
        
        signUpButton.frame = CGRect(
            x: 20, y: passwordTextField.bottom + 30,
            width: view.width - 40, height: 55)
        
        termsButton.frame = CGRect(
            x: 20, y: signUpButton.bottom + 30,
            width: view.width - 40, height: 55)
        
    }
    
    // MARK: - Behaviour
    
    private func configureButtons() {
        signUpButton.addTarget(
            self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(
            self, action: #selector(didTapTerms), for: .touchUpInside)
    }
    
    private func configureTextField() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(
            x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,target: self, action: nil),
            UIBarButtonItem(
                title: "Done", style: .done, target: self,
                action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        emailTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
        usernameTextField.inputAccessoryView = toolBar
    }
    
    @objc private func didTapSignUp() {
        didTapKeyboardDone()
        
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              username.contains(" "), username.contains("."),
              password.count >= 6 else {
            
            let alert = UIAlertController(
                title: "Woops",
                message: """
Please make sure to enter a valid username, email, and password. Your password must be more than 6 characters long
""",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismis", style: .cancel))
            present(alert, animated: true)
            
            return
        }
        
        AuthManager.shared.signIn(with: username, password) { success in
            //
        }
    }
    
    @objc private func didTapTerms() {
        didTapKeyboardDone()
        
        guard let url = URL(string: "https://www.tiktok.com/terms") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapKeyboardDone() {
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
