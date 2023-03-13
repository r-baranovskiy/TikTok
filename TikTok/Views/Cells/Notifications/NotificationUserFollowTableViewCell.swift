import UIKit

final class NotificationUserFollowTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationUserFollowTableViewCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        return button
    }()
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        selectionStyle = .none
        addSubview(avatarImageView)
        addSubview(userLabel)
        addSubview(followButton)
        addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpSize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        userLabel.text = nil
        dateLabel.text = nil
    }
    
    func configure(with username: String, model: Notification) {
        avatarImageView.image = UIImage(named: "testImageOne")
        userLabel.text = model.text
        dateLabel.text = .date(with: model.date)
    }
    
    private func setUpSize() {
        followButton.sizeToFit()
        dateLabel.sizeToFit()
        userLabel.sizeToFit()
        
        let iconSize: CGFloat = 50
        avatarImageView.frame = CGRect(
            x: 10, y: 3, width: iconSize, height: iconSize)
        
        avatarImageView.layer.cornerRadius = avatarImageView.height / 2
        avatarImageView.layer.masksToBounds = true
        
        followButton.frame = CGRect(
            x: contentView.width - 110, y: 10, width: 100, height: 30)
        
        let userLabelSize = userLabel.sizeThatFits(CGSize(
            width: contentView.width - 30 - followButton.width - iconSize,
            height: contentView.height - 40))
        userLabel.frame = CGRect(
            x: avatarImageView.right + 10, y: 0,
            width: userLabelSize.width, height: userLabelSize.height)
        
        dateLabel.frame = CGRect(
            x: avatarImageView.right + 10, y: userLabel.bottom + 3,
            width: contentView.width - avatarImageView.width - followButton.width,
            height: 40)
    }
}
