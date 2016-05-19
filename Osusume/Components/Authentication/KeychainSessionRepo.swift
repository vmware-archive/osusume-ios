import KeychainAccess

struct KeychainSessionRepo: SessionRepo {
    static let StoreServiceName = "osusume-store"

    private let httpTokenKeyName = "http-token"
    private let httpAuthIdKeyName = "http-auth_id"
    private let httpAuthEmailKeyName = "http-auth-email"

    let keychain = Keychain(service: StoreServiceName)

    func setAuthenticatedUser(authenticatedUser: AuthenticatedUser) {
        keychain[httpAuthIdKeyName] = "\(authenticatedUser.id)"
        keychain[httpTokenKeyName] = authenticatedUser.token
        keychain[httpAuthEmailKeyName] = authenticatedUser.email
    }

    func getAuthenticatedUser() -> AuthenticatedUser? {
        guard
            let idString = keychain[httpAuthIdKeyName],
            let idInt = Int(idString),
            let email = keychain[httpAuthEmailKeyName],
            let token = keychain[httpTokenKeyName] else {
                return nil
        }

        return AuthenticatedUser(
            id: idInt,
            email: email,
            token: token
        )
    }

    func deleteAuthenticatedUser() {
        keychain[httpAuthIdKeyName] = nil
        keychain[httpTokenKeyName] = nil
        keychain[httpAuthEmailKeyName] = nil
    }
}
