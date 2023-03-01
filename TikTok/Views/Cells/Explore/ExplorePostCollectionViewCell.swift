import UIKit

final class ExplorePostCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExplorePostCollectionViewCell"
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        let captionHeight = contentView.height / 5
        thumbnailImageView.frame = CGRect(
            x: 0, y: 0, width: contentView.width,
            height: contentView.height - captionHeight)
        captionLabel.frame = CGRect(
            x: 0, y: contentView.height - captionHeight,
            width: contentView.width, height: captionHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        captionLabel.text = nil
        
    }
    
    private func setUpContentView() {
        contentView.clipsToBounds = true
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(captionLabel)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    func configure(with viewModel: ExplorePostViewModel) {
        thumbnailImageView.image = viewModel.thumbnailImage
        captionLabel.text = viewModel.caption
    }
}
