import UIKit
import ProgressHUD

final class CaptionViewController: UIViewController {
    
    private let videoURL: URL
    
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
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post", style: .done, target: self,
            action: #selector(didTapPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc private func didTapPost() {
        let newVideoName = StorageManager.shared.generateVideoName()
        ProgressHUD.show("Posting")
        
        StorageManager.shared.uploadVideo(from: videoURL,
                                          fileName: newVideoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    DatabaseManager.shared.insertPost(fileName: newVideoName) { databaseUpdate in
                        if databaseUpdate {
                            ProgressHUD.dismiss()
                            HapticsManager.shared.vibrate(for: .success)
                            self?.navigationController?.popToRootViewController(animated: true)
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
