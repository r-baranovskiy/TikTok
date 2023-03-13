import UIKit

final class NotificationsViewController: UIViewController {
    
    // MARK: - UI Constants
    
    private let tablewView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(
            NotificationPostLikeTableViewCell.self,
            forCellReuseIdentifier: NotificationPostLikeTableViewCell.identifier)
        tableView.register(
            NotificationPostCommentTableViewCell.self,
            forCellReuseIdentifier: NotificationPostCommentTableViewCell.identifier)
        tableView.register(
            NotificationUserFollowTableViewCell.self,
            forCellReuseIdentifier: NotificationUserFollowTableViewCell.identifier)
        return tableView
    }()
    
    private let noNotificationsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .secondaryLabel
        label.text = "No Notifications"
        label.textAlignment = .center
        return label
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Variables
    
    private var notifications = [Notification]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        addSubviews()
        setUpRefreshControl()
        tablewView.delegate = self
        tablewView.dataSource = self
        fetchNotifications()
    }
    
    // MARK: - Behaviour
    
    private func setUpRefreshControl() {
        refreshControl.addTarget(
            self, action: #selector(didPullToRefresh), for: .valueChanged)
        tablewView.refreshControl = refreshControl
    }
    
    @objc private func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self?.notifications = notifications
                sender.endRefreshing()
                self?.tablewView.reloadData()
            })
        }
    }
    
    // MARK: - Appearance
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tablewView.frame = view.bounds
        noNotificationsLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noNotificationsLabel.center = view.center
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func addSubviews() {
        view.addSubview(tablewView)
        view.addSubview(noNotificationsLabel)
        view.addSubview(spinner)
    }
    
    private func fetchNotifications() {
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
        }
    }
    
    private func updateUI() {
        if notifications.isEmpty {
            noNotificationsLabel.isHidden = false
            tablewView.isHidden = true
        } else {
            noNotificationsLabel.isHidden = true
            tablewView.isHidden = false
        }
        
        tablewView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = notifications[indexPath.row]
        
        switch model.type {
        case .postLike(postName: let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationPostLikeTableViewCell.identifier,
                for: indexPath) as? NotificationPostLikeTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: postName, model: model)
            return cell
        case .userFollow(username: let userName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationUserFollowTableViewCell.identifier,
                for: indexPath) as? NotificationUserFollowTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: userName, model: model)
            return cell
        case .postComment(postName: let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationPostCommentTableViewCell.identifier,
                for: indexPath) as? NotificationPostCommentTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: postName, model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let notification = notifications[indexPath.row]
        notification.isHiden = true
        
        DatabaseManager.shared.markNotificationAsHidden(notificationID: notification.identifier) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.notifications = self?.notifications.filter({
                        $0.isHiden == false
                    }) ?? []
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                }
            }
        }
    }
}
