import UIKit

final class ExploreViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search..."
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        return bar
    }()
    
    private var sections = [ExploreSection]()
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        configureModels()
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func setUpSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureModels() {
        sections.append(
            ExploreSection(
                type: .banners,
                cells: ExploreManager.shared.getExploreBanners().compactMap({
                    return ExploreCell.banner(viewModel: $0)
                })
            )
        )
        
        
        var posts = [ExploreCell]()
        for _ in 0...40 {
            posts.append(
                ExploreCell.post(viewModel: ExplorePostViewModel(
                    thumbnailImage: nil, caption: "", handler: {
                        
                    }))
            )
        }
        
        sections.append(
            ExploreSection(
                type: .trendingPosts,
                cells: posts
            )
        )
        
        sections.append(
            ExploreSection(
                type: .users,
                cells: [
                    .user(viewModel: ExploreUserViewModel(
                        profilePicture: nil,
                        username: "",
                        followerCount: 10,
                        handler: {
                            //
                        }))
                ]
            )
        )
        
        sections.append(
            ExploreSection(
                type: .trendingHashtags,
                cells: [
                    .hashtag(viewModel: ExploreHashtagViewModel(
                        text: "#foryou",
                        icon: UIImage(systemName: "bell"),
                        count: 1,
                        handler: {
                            
                        })),
                    .hashtag(viewModel: ExploreHashtagViewModel(
                        text: "#iphone12",
                        icon: UIImage(systemName: "house"),
                        count: 1,
                        handler: {
                            
                        })),
                    .hashtag(viewModel: ExploreHashtagViewModel(
                        text: "#testtiktok",
                        icon: UIImage(systemName: "bell"),
                        count: 1,
                        handler: {
                            
                        })),
                    .hashtag(viewModel: ExploreHashtagViewModel(
                        text: "#foryou",
                        icon: nil,
                        count: 1,
                        handler: {
                            
                        })),
                    .hashtag(viewModel: ExploreHashtagViewModel(
                        text: "#foryou",
                        icon: nil,
                        count: 1,
                        handler: {
                            
                        }))
                ]
            )
        )
        
        sections.append(
            ExploreSection(
                type: .recommended,
                cells: [
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        }))
                ]
            )
        )
        
        sections.append(
            ExploreSection(
                type: .popular,
                cells: [
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        }))
                ]
            )
        )
        
        sections.append(
            ExploreSection(
                type: .new,
                cells: [
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                    .post(viewModel: ExplorePostViewModel(
                        thumbnailImage: nil, caption: "", handler: {
                            
                        }))
                ]
            )
        )
    }
    
    private func setUpCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.createCollectionViewLayout(for: section)
        }
        
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(
            ExploreBannerCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier)
        collectionView.register(
            ExplorePostCollectionViewCell.self,
            forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier)
        collectionView.register(
            ExploreUserCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier)
        collectionView.register(
            ExploreHashtagCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
}

// MARK: - UISearchBarDelegate

extension ExploreViewController: UISearchBarDelegate {
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(viewModel: let viewModel):
            break
        case .post(viewModel: let viewModel):
            break
        case .hashtag(viewModel: let viewModel):
            break
        case .user(viewModel: let viewModel):
            break
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreBannerCollectionViewCell.identifier,
                for: indexPath) as? ExploreBannerCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExplorePostCollectionViewCell.identifier,
                for: indexPath) as? ExplorePostCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
            return cell
        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier,
                for: indexPath) as? ExploreHashtagCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
            return cell
        case .user(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreUserCollectionViewCell.identifier,
                for: indexPath) as? ExploreUserCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
            return cell
        }
    }
}

// MARK: - Section Layouts

extension ExploreViewController {
    private func createCollectionViewLayout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        
        switch sectionType {
        case .banners:
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case .users:
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(150),
                heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case .trendingHashtags:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: verticalGroup)
            return section
            
        case .popular:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(200)),
                subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case  .trendingPosts, .new, .recommended:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(300)),
                subitem: item, count: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(300)),
                subitems: [verticalGroup])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
}
