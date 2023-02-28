import Foundation

enum ExploreSectionType: CaseIterable {
    case banners
    case users
    case trendingPosts
    case trendingHashtags
    case recommended
    case popular
    case new
    
    var title: String {
        switch self {
        case .banners:
            return "Featured"
        case .users:
            return "Popular Creators"
        case .trendingPosts:
            return "Trending Videos"
        case .trendingHashtags:
            return "Hashtags"
        case .recommended:
            return "Recommended"
        case .popular:
            return "Popular"
        case .new:
            return "Recently Posted"

        }
    }
}
