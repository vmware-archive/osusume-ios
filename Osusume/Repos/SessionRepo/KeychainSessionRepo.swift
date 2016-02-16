import KeychainAccess

class KeychainSessionRepo: SessionRepo {
    static let StoreServiceName: String = "osusume-token-store"

    private let httpTokenKeyName: String = "http-token"

    let keychain = Keychain(service: StoreServiceName)

    func setToken(token: String) {
        keychain[httpTokenKeyName] = token
    }

    func getToken() -> String? {
        return keychain[httpTokenKeyName]
    }

    func deleteToken() {
        keychain[httpTokenKeyName] = nil
    }
}
