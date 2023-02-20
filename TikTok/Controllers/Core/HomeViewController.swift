import UIKit

class HomeViewController: UIViewController {
    
    private let horizontalScrollView: UIScrollView = {
        let scollView = UIScrollView()
        scollView.bounces = false
        scollView.backgroundColor = .red
        scollView.isPagingEnabled = true
        scollView.showsHorizontalScrollIndicator = false
        return scollView
    }()
    
    private let forYouPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
    
    private let followingPageViewController = UIPageViewController(
        transitionStyle: .scroll, navigationOrientation: .vertical)
    
    private var forYouPost = PostModel.mockModels()
    private var followingPost = PostModel.mockModels()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        view.addSubview(horizontalScrollView)
        setUpFeed()
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    private func setUpFeed() {
        horizontalScrollView.contentSize = CGSize(
            width: view.width * 2, height: view.height)
        setUpFollowingFeed()
        setUpForYouFeed()
    }
    
    private func setUpFollowingFeed() {
        guard let model = followingPost.first else { return }
        
        followingPageViewController.setViewControllers(
            [PostViewController(model: model)],
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
        
        forYouPageViewController.setViewControllers(
            [PostViewController(model: model)],
            direction: .forward, animated: false)
        
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
        let vc = PostViewController(model: model)
        return vc
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
        let vc = PostViewController(model: model)
        return vc
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
