import KeychainAccess

struct KeychainSessionRepo: SessionRepo {
    static let StoreServiceName = "osusume-store"

    private let httpTokenKeyName = "http-token"
    private let httpAuthIdKeyName = "http-auth_id"
    private let httpAuthEmailKeyName = "http-auth-email"
    private let httpNameKeyName = "http-name"

    let keychain = Keychain(service: StoreServiceName)

    func setAuthenticatedUser(authenticatedUser: AuthenticatedUser) {
        keychain[httpAuthIdKeyName] = "\(authenticatedUser.id)"
        keychain[httpTokenKeyName] = authenticatedUser.token
        keychain[httpAuthEmailKeyName] = authenticatedUser.email
        keychain[httpNameKeyName] = authenticatedUser.name

    }

    func getAuthenticatedUser() -> AuthenticatedUser? {
        guard
            let idString = keychain[httpAuthIdKeyName],
            let idInt = Int(idString),
            let email = keychain[httpAuthEmailKeyName],
            let token = keychain[httpTokenKeyName],
            let name = keychain[httpNameKeyName] else {
                return nil
        }

        return AuthenticatedUser(
            id: idInt,
            email: email,
            token: token,
            name: name
        )
    }

    func deleteAuthenticatedUser() {
        keychain[httpAuthIdKeyName] = nil
        keychain[httpTokenKeyName] = nil
        keychain[httpAuthEmailKeyName] = nil
        keychain[httpNameKeyName] = nil
    }
}
