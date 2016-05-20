struct PersistedComment {
    let id: Int
    let text: String
    let createdDate: NSDate
    let restaurantId: Int
    let userId: Int
    let userName: String
}

extension PersistedComment: Equatable {}

func ==(lhs: PersistedComment, rhs: PersistedComment) -> Bool {
    return lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.createdDate == rhs.createdDate &&
        lhs.restaurantId == rhs.restaurantId &&
        lhs.userId == rhs.userId &&
        lhs.userName == rhs.userName
}
