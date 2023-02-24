import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentsViewController)
}

final class CommentsViewController: UIViewController {
    
    weak var delegate: CommentsViewControllerDelegate?
    
    private var comments = [PostComment]()
    
    private let commentTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.identifier)
        return tableView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let post: PostModel
    
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(
            closeButtonDidTap), for: .touchUpInside)
        view.addSubview(commentTableView)
        commentTableView.delegate = self
        commentTableView.dataSource = self
        fetchComments()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 45, y: 10,
                                   width: 35, height: 35)
        
        commentTableView.frame = CGRect(x: 0, y: closeButton.bottom,
                                        width: view.width,
                                        height: view.width - closeButton.bottom)
    }
    
    @objc private func closeButtonDidTap() {
        delegate?.didTapCloseForComments(with: self)
    }
    
    private func fetchComments() {
        comments = PostComment.mockComments()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let comment = comments[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.identifier,
            for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: comment)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
