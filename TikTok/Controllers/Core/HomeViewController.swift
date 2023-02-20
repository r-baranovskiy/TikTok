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
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        
        followingPageViewController.setViewControllers(
            [vc], direction: .forward, animated: false)
        
        followingPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(followingPageViewController.view)
        followingPageViewController.view.frame = CGRect(x: 0, y: 0,
                                           width: horizontalScrollView.width,
                                           height: horizontalScrollView.height)
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
    }
    
    private func setUpForYouFeed() {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        
        forYouPageViewController.setViewControllers(
            [vc], direction: .forward, animated: false)
        
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
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = [UIColor.red, UIColor.gray, UIColor.green].randomElement()
        return vc
    }
    
    
}
