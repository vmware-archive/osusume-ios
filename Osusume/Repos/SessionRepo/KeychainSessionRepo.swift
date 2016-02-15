import KeychainAccess

class KeychainSessionRepo: SessionRepo {
    static let STORE_SERVICE_NAME: String = "osususme-token-store"

    private let HTTP_TOKEN: String = "http-token"

    let keychain = Keychain(service: STORE_SERVICE_NAME)

    func setToken(token: String) {
        keychain[HTTP_TOKEN] = token
    }

    func getToken() -> String? {
        return keychain[HTTP_TOKEN]
    }

    func deleteToken() {
        keychain[HTTP_TOKEN] = nil
    }
}
