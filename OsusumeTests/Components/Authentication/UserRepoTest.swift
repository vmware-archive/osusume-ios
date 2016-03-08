import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class UserRepoTest: XCTestCase {
    let fakeHttp = FakeHttp()
    var userRepo: UserRepo!

    func test_login_callsPostWithEmailAndPasswordAndReturnsToken() {
        userRepo = HttpUserRepo(http: fakeHttp)
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
}
