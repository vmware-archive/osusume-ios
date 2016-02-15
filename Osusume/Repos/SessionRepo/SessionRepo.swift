import KeychainAccess

class SessionRepo {
    private let HTTP_TOKEN: String = "http-token"
    static let STORE_SERVICE_NAME: String = "osususme-token-store"

    let keychain = Keychain(service: STORE_SERVICE_NAME)

    func getToken() -> String? {
        return keychain[HTTP_TOKEN]
    }

    func deleteToken() {
        keychain[HTTP_TOKEN] = nil
    }

    func setToken(token: String) {
        keychain[HTTP_TOKEN] = token
    }
}
