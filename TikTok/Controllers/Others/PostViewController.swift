import UIKit
import AVFoundation

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController,
                            didTapCommentButtonFor post: PostModel)
    func postViewController(_ vc: PostViewController, didTapProfileButton post: PostModel )
}

final class PostViewController: UIViewController {
    
    weak var delegate: PostViewControllerDelegate?
    
    private var playerDidFinishObserver: NSObjectProtocol?
    
    var model: PostModel
    
    var player: AVPlayer?
    
    // MARK: - UI Constants
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(
            systemName: model.isLikedByCurrentUser ? "heart.fill" : "heart"),
                                  for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(
            UIImage(systemName: "text.bubble"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(
            UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(
            UIImage(named: "testImageOne"), for: .normal)
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let caprionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24)
        label.text = "Check out this video #fyp #foryou #foryoupage"
        label.textColor = .white
        return label
    }()
    
    // MARK: - Init
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideo()
        configurePostView()
        setUpDoubleTapToLike()
        addTargets()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpSizeForButtons()
        setUpSizeForLabel()
    }
    
    // MARK: - Behaviour
    
    private func configureVideo() {
        guard let path = Bundle.main.path(
            forResource: "test-video", ofType: "mp4") else {
            return
        }
        
        var url: URL
        if #available(iOS 16.0, *) {
            url = URL.init(filePath: path)
        } else {
            url = URL(fileURLWithPath: path)
        }
        
        player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        player?.volume = 1.0
        player?.play()
        
        createPlayerNotification()
    }
    
    private func createPlayerNotification() {
        guard let player = player else { return }
        
        playerDidFinishObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem,
            queue: .main, using: { _ in
                player.seek(to: .zero)
                player.play()
            })
    }
    
    private func setUpDoubleTapToLike() {
        let tap = UITapGestureRecognizer(
            target: self, action: #selector(didDoubleTap))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    private func addTargets() {
        profileButton.addTarget(
            self, action: #selector(profileButtonDidTap), for: .touchUpInside)
        likeButton.addTarget(
            self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        commentButton.addTarget(
            self, action: #selector(commentButtonDidTap), for: .touchUpInside)
        shareButton.addTarget(
            self, action: #selector(shareButtonDidTap), for: .touchUpInside)
    }
    
    private func addLike() {
        showLikeAnimation()
        likeButton.setBackgroundImage(UIImage(
            systemName: model.isLikedByCurrentUser ? "heart" : "heart.fill"),
                                      for: .normal)
        showLikeAnimation()
        if !model.isLikedByCurrentUser {
            model.isLikedByCurrentUser = true
        } else {
            model.isLikedByCurrentUser = false
        }
    }
    
    // MARK: - @objc buttons func
    
    @objc private func profileButtonDidTap() {
        delegate?.postViewController(self, didTapProfileButton: model)
    }
    
    @objc private func didDoubleTap() {
        addLike()
    }
    
    @objc private func likeButtonDidTap() {
        addLike()
    }
    
    @objc private func commentButtonDidTap() {
        delegate?.postViewController(self, didTapCommentButtonFor: model)
    }
    
    @objc private func shareButtonDidTap() {
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        
        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: [])
        
        present(activityVC, animated: true)
    }
    
    // MARK: - Appearance
    
    private func configurePostView() {
        let colors: [UIColor] = [
            .red, .green, .black, .orange, .blue, .gray, .systemPink
        ]
        view.backgroundColor = colors.randomElement()
        view.addSubview(caprionLabel)
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        view.addSubview(profileButton)
    }
    
    private func setUpSizeForButtons() {
        let size: CGFloat = 40
        let tabBarHeight: CGFloat = tabBarController?.tabBar.height ?? 0
        
        let yStart: CGFloat = view.height - (size * 4) - 30 -
        view.safeAreaInsets.bottom - tabBarHeight
        
        for (index, button) in [likeButton, commentButton, shareButton]
            .enumerated() {
            button.frame = CGRect(
                x: view.width - size - 10, y: yStart + (CGFloat(index) * 10) +
                (CGFloat(index) * size),
                width: size, height: size)
        }
        
        profileButton.frame = CGRect(x: likeButton.left,
                                     y: likeButton.top - 10 - size,
                                     width: size, height: size)
        profileButton.layer.cornerRadius = size / 2
    }
    
    private func setUpSizeForLabel() {
        caprionLabel.sizeToFit()
        let labelSize = caprionLabel.sizeThatFits(CGSize(
            width: view.width - 52, height: view.height))
        
        caprionLabel.frame = CGRect(
            x: 5, y: view.height - 10 - view.safeAreaInsets.bottom -
            labelSize.height - (tabBarController?.tabBar.height ?? 0),
            width: view.width - 52, height: labelSize.height)
    }
    
    private func showLikeAnimation() {
        let likeImageView = UIImageView(image: UIImage(
            systemName: model.isLikedByCurrentUser ? "heart.slash.fill" : "heart.fill"))
        likeImageView.tintColor = .white
        likeImageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        likeImageView.center = view.center
        likeImageView.contentMode = .scaleAspectFit
        likeImageView.alpha = 0
        view.addSubview(likeImageView)
        
        UIView.animate(withDuration: 0.2) {
            likeImageView.alpha = 1
        } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    UIView.animate(withDuration: 0.3) {
                        likeImageView.alpha = 0
                    } completion: { done in
                        if done {
                            likeImageView.removeFromSuperview()
                        }
                    }
                    
                }
            }
        }
    }
}
