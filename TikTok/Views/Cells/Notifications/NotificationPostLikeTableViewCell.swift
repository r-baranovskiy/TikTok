import UIKit

final class NotificationPostLikeTableViewCell: UITableViewCell {
    
    static let identifier = "NotificationPostLikeTableViewCell"
    
    private let postThumbnailImageView: UIImageView = {
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
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        selectionStyle = .none
        addSubview(postThumbnailImageView)
        addSubview(userLabel)
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
        postThumbnailImageView.image = nil
        userLabel.text = nil
        dateLabel.text = nil
    }
    
    func configure(with postFileName: String, model: Notification) {
        postThumbnailImageView.image = UIImage(named: "testImageOne")
        userLabel.text = model.text
        dateLabel.text = .date(with: model.date)
    }
    
    private func setUpSize() {
        dateLabel.sizeToFit()
        userLabel.sizeToFit()
        
        postThumbnailImageView.frame = CGRect(
            x: contentView.width - 50, y: 3,
            width: 50, height: contentView.height - 6)
        
        let userLabelSize = userLabel.sizeThatFits(CGSize(
            width: contentView.width - 10 - postThumbnailImageView.width - 5,
            height: contentView.height - 40))
        userLabel.frame = CGRect(
            x: 10, y: 0, width: userLabelSize.width, height: userLabelSize.height)
        
        dateLabel.frame = CGRect(
            x: 10, y: userLabel.bottom + 3,
            width: contentView.width - postThumbnailImageView.width,
            height: 40)
    }
}
