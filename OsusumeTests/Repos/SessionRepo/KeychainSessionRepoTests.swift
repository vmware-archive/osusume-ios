import XCTest
import KeychainAccess
import Nimble
@testable import Osusume

class KeychainSessionRepoTests: XCTestCase {

    var keychainSessionRepo: KeychainSessionRepo!
    var keychain: Keychain!

    private let HttpTokenKeyName = "http-token"

    override func setUp() {
        super.setUp()

        keychainSessionRepo = KeychainSessionRepo()
        keychain = Keychain(service: "osususme-token-store")
    }
    
    override func tearDown() {
        keychain[HttpTokenKeyName] = nil

        super.tearDown()
    }

    func testHttpTokenInitializesToNil() {
        expect(self.keychain[self.HttpTokenKeyName]).to(beNil())
    }

    func testSetSessionToken_setsTheSessionToken() {
        keychainSessionRepo.setToken("some-token-value")
        expect(self.keychain[self.HttpTokenKeyName]).to(equal("some-token-value"))
    }

    func testGetToken_returnsTheTokenValue() {
        let tokenValue = keychainSessionRepo.getToken()
        expect(tokenValue).to(beNil())

        keychain[HttpTokenKeyName] = "new-token-value"

        let newTokenValue = keychainSessionRepo.getToken()
        expect(newTokenValue).to(equal("new-token-value"))
    }

    func testDeleteToken_deletesTheTokenValue() {
        keychain[HttpTokenKeyName] = "new-token-value"

        keychainSessionRepo.deleteToken()
        expect(self.keychain[self.HttpTokenKeyName]).to(beNil())
    }

}
