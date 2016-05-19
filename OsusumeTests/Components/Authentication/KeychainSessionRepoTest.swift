import XCTest
import KeychainAccess
import Nimble
@testable import Osusume

class KeychainSessionRepoTest: XCTestCase {

    var keychainSessionRepo: KeychainSessionRepo!
    var keychain: Keychain!

    private let HttpTokenKeyName = "http-token"
    private let HttpAuthIdKeyName = "http-auth_id"
    private let HttpAuthEmailKeyName = "http-auth-email"

    override func setUp() {
        super.setUp()

        keychainSessionRepo = KeychainSessionRepo()
        keychain = Keychain(service: "osusume-store")
    }

    override func tearDown() {
        keychain[HttpTokenKeyName] = nil
        keychain[HttpAuthIdKeyName] = nil
        keychain[HttpAuthEmailKeyName] = nil

        super.tearDown()
    }

    func test_setAuthenticatedUser_setsAuthenticatedUserInfo() {
        keychainSessionRepo.setAuthenticatedUser(AuthenticatedUser(id: 1, email: "authUser", token: "tokenString"))


        expect(self.keychain[self.HttpAuthIdKeyName]).to(equal("1"))
        expect(self.keychain[self.HttpAuthEmailKeyName]).to(equal("authUser"))
        expect(self.keychain[self.HttpTokenKeyName]).to(equal("tokenString"))
    }

    func test_getAuthenticatedUser_returnsAuthenticatedUser() {
        let authUser = keychainSessionRepo.getAuthenticatedUser()
        expect(authUser).to(beNil())


        keychain[HttpTokenKeyName] = "token"
        keychain[HttpAuthIdKeyName] = "1"
        keychain[HttpAuthEmailKeyName] = "email"


        let newAuthUser = keychainSessionRepo.getAuthenticatedUser()


        expect(newAuthUser!.token).to(equal("token"))
        expect(newAuthUser!.id).to(equal(1))
        expect(newAuthUser!.email).to(equal("email"))
    }

    func test_deleteAuthenticatedUser_deletesAuthenticatedUser() {
        keychain[HttpAuthIdKeyName] = "1"
        keychain[HttpAuthEmailKeyName] = "email"
        keychain[HttpTokenKeyName] = "token"

        
        keychainSessionRepo.deleteAuthenticatedUser()


        expect(self.keychain[self.HttpAuthIdKeyName]).to(beNil())
        expect(self.keychain[self.HttpAuthEmailKeyName]).to(beNil())
        expect(self.keychain[self.HttpTokenKeyName]).to(beNil())
    }
}
