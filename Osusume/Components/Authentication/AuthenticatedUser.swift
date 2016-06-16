struct AuthenticatedUser {
    let id: Int
    let email: String
    let token: String
    let name: String
}

extension AuthenticatedUser: Equatable {}

func ==(lhs: AuthenticatedUser, rhs: AuthenticatedUser) -> Bool {
    return lhs.id == rhs.id &&
        lhs.email == rhs.email &&
        lhs.token == rhs.token &&
        lhs.name == rhs.name
}