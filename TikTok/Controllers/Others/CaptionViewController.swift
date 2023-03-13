import UIKit
import ProgressHUD

final class CaptionViewController: UIViewController {
    
    private let videoURL: URL
    
    private let cationTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3,
                                             bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        return textView
    }()
    
    // MARK: - Init
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.addSubview(cationTextView)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post", style: .done, target: self,
            action: #selector(didTapPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cationTextView.frame = CGRect(
            x: 5, y: view.safeAreaInsets.top + 5,
            width: view.width - 10, height: 150).integral
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cationTextView.becomeFirstResponder()
    }
    
    // MARK: - Behaviour
    
    @objc private func didTapPost() {
        cationTextView.resignFirstResponder()
        let caption = cationTextView.text ?? ""
        
        let newVideoName = StorageManager.shared.generateVideoName()
        ProgressHUD.show("Posting")
        
        StorageManager.shared.uploadVideo(from: videoURL,
                                          fileName: newVideoName)
        { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    DatabaseManager.shared.insertPost(fileName: newVideoName, caption: caption) { databaseUpdate in
                        if databaseUpdate {
                            ProgressHUD.dismiss()
                            HapticsManager.shared.vibrate(for: .success)
                            self?.navigationController?
                                .popToRootViewController(animated: true)
                            self?.tabBarController?.selectedIndex = 0
                            self?.tabBarController?.tabBar.isHidden = false
                        } else {
                            ProgressHUD.dismiss()
                            HapticsManager.shared.vibrate(for: .error)
                            let alert = UIAlertController.createErrorWarning(
                                message: "We were unable to upload your video. Please try again.")
                            self?.present(alert, animated: true)
                        }
                    }
                } else {
                    ProgressHUD.dismiss()
                    HapticsManager.shared.vibrate(for: .error)
                    let alert = UIAlertController.createErrorWarning(
                        message: "We were unable to upload your video. Please try again.")
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
