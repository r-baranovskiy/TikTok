import Foundation

enum NotificationType {
    case postLike(postName: String)
    case userFollow(username: String)
    case postComment(postName: String)
    
    var id: String {
        switch self {
        case .postLike:
            return "postLike"
        case .userFollow:
            return "userFollow"
        case .postComment:
            return "postComment"
        }
    }
}

final class Notification {
    let identifier = UUID().uuidString
    var isHiden = false
    let text: String
    let type: NotificationType
    let date: Date
    
    init(text: String, type: NotificationType, date: Date) {
        self.text = text
        self.type = type
        self.date = date
    }
    
    static func mockData() -> [Notification] {
        return Array(0...100).compactMap({
            Notification(
                text: "Something happened \($0)",
                type: .postComment(postName: "ANASTASIYA "),
                date: Date())
        })
    }
}
