import UIKit

class HomeViewController: UIViewController {
    
    private let horizontalScrollView: UIScrollView = {
        let scollView = UIScrollView()
        scollView.bounces = false
        scollView.isPagingEnabled = true
        scollView.showsHorizontalScrollIndicator = false
        return scollView
    }()
    
    private let forYouPageViewController = UIPageViewController(
        transitionStyle: .scroll, navigationOrientation: .vertical)
    
    private let followingPageViewController = UIPageViewController(
        transitionStyle: .scroll, navigationOrientation: .vertical)
    
    private var forYouPost = PostModel.mockModels()
    private var followingPost = PostModel.mockModels()
    
    private let control: UISegmentedControl = {
        let titles = ["Following", "For You"]
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 1
        control.backgroundColor = nil
        control.selectedSegmentTintColor = .white
        return control
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        view.addSubview(horizontalScrollView)
        setUpFeed()
        horizontalScrollView.contentInsetAdjustmentBehavior = .never
        horizontalScrollView.delegate = self
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        setUpHeaderButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    // MARK: - Header
    
    private func setUpHeaderButtons() {
        control.addTarget(self, action: #selector(didChangeSegmentControl),
                          for: .valueChanged)
        navigationItem.titleView = control
    }
    
    @objc private func didChangeSegmentControl(_ sender: UISegmentedControl) {
        horizontalScrollView.setContentOffset(
            CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex),
                    y: 0), animated: true)
    }
    
    
    // MARK: - Scroll
    
    private func setUpFeed() {
        horizontalScrollView.contentSize = CGSize(
            width: view.width * 2, height: view.height)
        setUpFollowingFeed()
        setUpForYouFeed()
    }
    
    private func setUpFollowingFeed() {
        guard let model = followingPost.first else { return }
        
        let postVC = PostViewController(model: model)
        postVC.delegate = self
        
        followingPageViewController.setViewControllers(
            [postVC],
            direction: .forward, animated: false)
        
        followingPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(followingPageViewController.view)
        followingPageViewController.view.frame = CGRect(x: 0, y: 0,
                                                        width: horizontalScrollView.width,
                                                        height: horizontalScrollView.height)
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
    }
    
    private func setUpForYouFeed() {
        guard let model = forYouPost.first else { return }
        
        let postVC = PostViewController(model: model)
        postVC.delegate = self
        forYouPageViewController.setViewControllers(
            [postVC], direction: .forward, animated: false)
        
        forYouPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(forYouPageViewController.view)
        forYouPageViewController.view.frame = CGRect(x: view.width, y: 0,
                                                     width: horizontalScrollView.width,
                                                     height: horizontalScrollView.height)
        addChild(forYouPageViewController)
        forYouPageViewController.didMove(toParent: self)
    }
}

// MARK: - UIPageViewControllerDataSource

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        if index == 0 {
            return nil
        }
        
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let postVC = PostViewController(model: model)
        postVC.delegate = self
        return postVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        guard index < currentPosts.count - 1 else {
            return nil
        }
        
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let postVC = PostViewController(model: model)
        postVC.delegate = self
        return postVC
    }
    
    var currentPosts: [PostModel] {
        if horizontalScrollView.contentOffset.x == 0 {
            // Following
            return followingPost
        } else {
            // For you
            return forYouPost
        }
    }
}

// MARK: - UIScrollViewDelegate

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= view.width / 2 {
            control.selectedSegmentIndex = 0
        } else if scrollView.contentOffset.x > view.width / 2 {
            control.selectedSegmentIndex = 1
        }
    }
}

// MARK: - PostViewControllerDelegate

extension HomeViewController: PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapProfileButton post: PostModel) {
        let user = post.user
        let profileVC = ProfileViewController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func postViewController(_ vc: PostViewController,
                            didTapCommentButtonFor post: PostModel) {
        horizontalScrollView.isScrollEnabled = false
        
        if horizontalScrollView.contentOffset.x == 0 {
            followingPageViewController.dataSource = nil
        } else {
            forYouPageViewController.dataSource = nil
        }
        let commentVC = CommentsViewController(post: post)
        commentVC.delegate = self
        addChild(commentVC)
        commentVC.didMove(toParent: self)
        view.addSubview(commentVC.view)
        let frame: CGRect = CGRect(
            x: 0, y: view.height, width: view.width,
            height: view.height * 0.75)
        commentVC.view.frame = frame
        
        UIView.animate(withDuration: 0.2) {
            commentVC.view.frame = CGRect(
                x: 0, y: self.view.height - frame.height,
                width: frame.width, height: frame.height)
        }
    }
}

extension HomeViewController: CommentsViewControllerDelegate {
    func didTapCloseForComments(with viewController: CommentsViewController) {
        let frame = viewController.view.frame
        
        UIView.animate(withDuration: 0.2) {
            viewController.view.frame = CGRect(
                x: 0, y: self.view.height, width: frame.width,
                height: frame.height)
        } completion: { [weak self] done in
            if done {
                DispatchQueue.main.async {
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    
                    self?.horizontalScrollView.isScrollEnabled = true
                    self?.forYouPageViewController.dataSource = self
                    self?.followingPageViewController.dataSource = self
                }
            }
        }
    }
}
