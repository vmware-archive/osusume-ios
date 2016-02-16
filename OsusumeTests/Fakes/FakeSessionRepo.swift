@testable import Osusume

class FakeSessionRepo: SessionRepo {
    var tokenValue: String? = nil

    var setTokenWasCalled = false
    func setToken(token: String) {
        setTokenWasCalled = true
        tokenValue = token
    }

    var getTokenWasCalled = false
    func getToken() -> String? {
        getTokenWasCalled = true
        return tokenValue
    }

    var deleteTokenWasCalled = false
    func deleteToken() {
        deleteTokenWasCalled = true
        tokenValue = nil
    }

}
