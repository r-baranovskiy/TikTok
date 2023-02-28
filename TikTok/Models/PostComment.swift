import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [PostComment] {
        let user = User(username: "Ruslan", profilePictureURL: nil,
                        identifier: UUID().uuidString)
        
        var comments = [PostComment]()
        
        let texts = [
            "This is cool",
            "Loks liks a fool",
            "I'm shocked"
        ]
        
        for comment in texts {
            comments.append(PostComment(text: comment, user: user, date: Date()))
        }
        
        return comments
    }
}
