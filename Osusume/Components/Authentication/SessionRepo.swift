protocol SessionRepo {
    func setAuthenticatedUser(authenticatedUser: AuthenticatedUser)
    func getAuthenticatedUser() -> AuthenticatedUser?
    func deleteAuthenticatedUser()
}
