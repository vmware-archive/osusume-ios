@testable import Osusume

class FakeSessionRepo: SessionRepo {
    var setAuthenticatedUser_arg = AuthenticatedUser(id: -1, email: "", token: "", name: "")
    func setAuthenticatedUser(authenticatedUser: AuthenticatedUser) {
        setAuthenticatedUser_arg = authenticatedUser
    }

    var getAuthenticatedUser_returnValue: AuthenticatedUser? = nil
    func getAuthenticatedUser() -> AuthenticatedUser? {
        return getAuthenticatedUser_returnValue
    }

    var deleteAuthenticatedUser_wasCalled = false
    func deleteAuthenticatedUser() {
        deleteAuthenticatedUser_wasCalled = true
    }
}
