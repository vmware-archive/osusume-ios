struct NewComment {
    let text: String
    let restaurantId: Int
}

extension NewComment: Equatable {}

func ==(lhs: NewComment, rhs: NewComment) -> Bool {
    return lhs.text == rhs.text &&
        lhs.restaurantId == rhs.restaurantId
}
