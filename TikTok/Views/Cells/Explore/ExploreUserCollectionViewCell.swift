import UIKit

final class ExploreUserCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExploreUserCollectionViewCell"
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 55
        
        profileImageView.frame = CGRect(
            x: (contentView.width - imageSize) / 2,
            y: 0, width: imageSize, height: imageSize)
        profileImageView.layer.cornerRadius = profileImageView.height / 2
        
        usernameLabel.frame = CGRect(
            x: 0, y: profileImageView.bottom,
            width: contentView.width, height: 55)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        usernameLabel.text = nil
    }
    
    private func setUpContentView() {
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
    }
    
    func configure(with viewModel: ExploreUserViewModel) {
        profileImageView.image = viewModel.profilePicture
        usernameLabel.text = viewModel.username
    }
}
