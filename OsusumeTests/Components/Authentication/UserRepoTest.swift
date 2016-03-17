import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class UserRepoTest: XCTestCase {
    let fakeHttp = FakeHttp()
    var userRepo: UserRepo!
    let fakeSessionRepo = FakeSessionRepo()

    override func setUp() {
        fakeSessionRepo.tokenValue = "some-session-token"

        userRepo = NetworkUserRepo(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo
        )
    }

    func test_login_callsPostWithEmailAndPasswordAndReturnsToken() {
        let promise = Promise<[String: AnyObject], RepoError>()
        fakeHttp.post_returnValue = promise.future

        let token = userRepo.login("my-email", password: "my-password")

        expect(self.fakeHttp.post_args.path).to(equal("/login"))
        expect(self.fakeHttp.post_args.parameters["email"] as? String).to(equal("my-email"))
        expect(self.fakeHttp.post_args.parameters["password"] as? String).to(equal("my-password"))

        promise.success(["token": "my-token"])
        NSRunLoop.osu_advance()
        expect(token.value).to(equal("my-token"))
    }

    func test_fetchCurrentUser_returnsUserName() {
        let promise = Promise<AnyObject, RepoError>()
        fakeHttp.get_returnValue = promise.future

        let userName = userRepo.fetchCurrentUserName()

        promise.success(["name": "awesome-user-name"])
        NSRunLoop.osu_advance()
        expect(userName.value).to(equal("awesome-user-name"))
    }
}
