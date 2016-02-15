@testable import Osusume

class FakeSessionRepo: SessionRepo {
    var tokenValue: String? = nil

    func setToken(token: String) {
        tokenValue = token
    }

    func getToken() -> String? {
        return tokenValue
    }

    func deleteToken() {
        tokenValue = nil
    }

}
