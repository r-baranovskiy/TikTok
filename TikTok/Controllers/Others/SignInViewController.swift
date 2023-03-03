import UIKit

final class SignInViewController: UIViewController {
    
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
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpSizes()
    }
    
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
    
    private func configureButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignIn),
                               for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp),
                               for: .touchUpInside)
        forgotPasswordButton.addTarget(
            self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    // MARK: - Behaviour
    
    @objc private func didTapSignIn() {
        
    }
    
    @objc private func didTapSignUp() {
        
    }
    
    @objc private func didTapForgotPassword() {
        
    }
}

extension SignInViewController: UITextFieldDelegate {
    
}

import SwiftUI
struct ListProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let listVC = SignInViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListProvider.ContainerView>) -> SignInViewController {
            return listVC
        }
        
        func updateUIViewController(_ uiViewController: ListProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListProvider.ContainerView>) {
        }
    }
}

