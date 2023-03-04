import UIKit
import SafariServices

final class SignInViewController: UIViewController, UITextFieldDelegate {
    
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
    
    private let signInButton = AuthButton(type: .signIn)
    private let forgotPasswordButton = AuthButton(
        type: .plain, title: "Forgot Password")
    private let signUpButton = AuthButton(
        type: .plain, title: "New User? Create account")
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
        addSubview()
        configureButtons()
        configureTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpSizes()
    }
    
    // MARK: - Appearance
    
    private func addSubview() {
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(forgotPasswordButton)
    }
    
    private func setUpSizes() {
        let imageSize: CGFloat = 100
        logoImageView.frame = CGRect(
            x: (view.width - imageSize) / 2, y: view.safeAreaInsets.top + 5,
            width: imageSize, height: imageSize)
        
        emailTextField.frame = CGRect(
            x: 20, y: logoImageView.bottom + 20,
            width: view.width - 40, height: 55)
        
        passwordTextField.frame = CGRect(
            x: 20, y: emailTextField.bottom + 15,
            width: view.width - 40, height: 55)
        
        signInButton.frame = CGRect(
            x: 20, y: passwordTextField.bottom + 30,
            width: view.width - 40, height: 55)
        
        forgotPasswordButton.frame = CGRect(
            x: 20, y: signInButton.bottom + 30,
            width: view.width - 40, height: 55)
        
        signUpButton.frame = CGRect(
            x: 20, y: forgotPasswordButton.bottom + 30,
            width: view.width - 40, height: 55)
    }
    
    // MARK: - Behaviour
    
    private func configureButtons() {
        signInButton.addTarget(
            self, action: #selector(didTapSignIn), for: .touchUpInside)
        signUpButton.addTarget(
            self, action: #selector(didTapSignUp), for: .touchUpInside)
        forgotPasswordButton.addTarget(
            self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    private func configureTextField() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
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
    }
    
    @objc private func didTapSignIn() {
        didTapKeyboardDone()
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            
            let alert = UIAlertController(
                title: "Woops",
                message: "Please enter a valid email and password to sign in",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismis", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        AuthManager.shared.signIn(with: email, password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.dismiss(animated: true)
                case .failure(let error):
                    let alert = UIAlertController(
                        title: "Sign In Failed",
                        message: error.localizedDescription,
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismis", style: .cancel))
                    self?.present(alert, animated: true)
                    self?.passwordTextField.text = nil
                }
            }
        }
    }
    
    @objc private func didTapSignUp() {
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgotPassword() {
        didTapKeyboardDone()
        guard let url = URL(
            string: "https://www.tiktok.com/forgot-password") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapKeyboardDone() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

