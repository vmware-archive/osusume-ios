struct PersistedComment {
    let id: Int
    let text: String
    let restaurantId: Int
}

extension PersistedComment: Equatable {}

func ==(lhs: PersistedComment, rhs: PersistedComment) -> Bool {
    return lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.restaurantId == rhs.restaurantId
}
