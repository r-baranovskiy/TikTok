import UIKit

final class ExploreHashtagCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExploreHashtagCollectionViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    private let hashtagLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .medium)
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
        let iconSize: CGFloat = contentView.height / 3
        iconImageView.frame = CGRect(
            x: 10, y: (contentView.height - iconSize) / 2,
            width: iconSize, height: iconSize).integral
        
        hashtagLabel.sizeToFit()
        hashtagLabel.frame = CGRect(
            x: iconImageView.right + 10, y: 0,
            width: contentView.width - iconImageView.right - 10,
            height: contentView.height).integral
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        hashtagLabel.text = nil
    }
    
    private func setUpContentView() {
        contentView.backgroundColor = .systemGray5
        contentView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        contentView.addSubview(hashtagLabel)
    }
    
    func configure(with viewModel: ExploreHashtagViewModel) {
        iconImageView.image = viewModel.icon
        hashtagLabel.text = viewModel.text
    }
}
