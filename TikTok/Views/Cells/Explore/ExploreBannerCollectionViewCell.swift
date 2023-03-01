import UIKit

final class ExploreBannerCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExploreBannerCollectionViewCell"
    
    // MARK: - Constants
    
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let bannerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpContentView()
        bannerLabel.sizeToFit()
        bannerImageView.frame = contentView.bounds
        bannerLabel.frame = CGRect(
            x: 10, y: contentView.height - 5 - bannerLabel.height,
            width: bannerLabel.width, height: bannerLabel.height)
        contentView.bringSubviewToFront(bannerLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bannerImageView.image = nil
        bannerLabel.text = nil
    }
    
    private func setUpContentView() {
        contentView.clipsToBounds = true
        contentView.addSubview(bannerImageView)
        contentView.addSubview(bannerLabel)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func configure(with viewModel: ExploreBannerViewModel) {
        bannerImageView.image = viewModel.image
        bannerLabel.text = viewModel.title
    }
}
