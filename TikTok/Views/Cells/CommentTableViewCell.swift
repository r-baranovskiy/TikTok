import UIKit

final class CommentTableViewCell: UITableViewCell {
    
    static let identifier = "CommentTableViewCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        addSubview(avatarImageView)
        addSubview(commentLabel)
        addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpSizes()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        commentLabel.text = nil
        dateLabel.text = nil
    }
    
    private func setUpSizes() {
        commentLabel.sizeToFit()
        dateLabel.sizeToFit()
        
        let imageSize: CGFloat = 44
        avatarImageView.frame = CGRect(
            x: 10, y: 5,
            width: imageSize, height: imageSize)
        
        let commentLabelHeight = min(contentView.height - dateLabel.top,
                                     commentLabel.height)
        
        commentLabel.frame = CGRect(
            x: avatarImageView.right + 10, y: 5,
            width: contentView.width - avatarImageView.right - 10,
            height: commentLabelHeight)
        
        dateLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: commentLabel.bottom,
            width: dateLabel.width, height: dateLabel.height)
    }
    
    public func configure(with model: PostComment) {
        if let url = model.user.profilePictureURL {
            print(url)
        } else {
            avatarImageView.image = UIImage(systemName: "person.circle")
        }
        
        commentLabel.text = model.text
        dateLabel.text = .date(with: model.date)
    }
}
