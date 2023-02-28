import Foundation

struct ExploreUserViewModel {
    let profilePictureURL: URL?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
