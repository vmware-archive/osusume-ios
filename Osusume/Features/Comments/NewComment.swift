struct NewComment {
    let text: String
}

extension NewComment: Equatable {}

func ==(lhs: NewComment, rhs: NewComment) -> Bool {
    return lhs.text == rhs.text
}
