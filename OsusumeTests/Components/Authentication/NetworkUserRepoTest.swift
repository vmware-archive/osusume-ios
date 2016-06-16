import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class NetworkUserRepoTest: XCTestCase {
    let fakeHttp = FakeHttp()
    var userRepo: UserRepo!

    override func setUp() {
        userRepo = NetworkUserRepo(
            http: fakeHttp,
            restaurantListRepo: NetworkRestaurantListRepo(
                http: fakeHttp,
                parser: RestaurantParser()
            )
        )
    }

    func test_login_callsPostWithEmailAndPasswordAndReturnsToken() {
        let promise = Promise<[String: AnyObject], RepoError>()
        fakeHttp.post_returnValue = promise.future

        let authenticatedUser = userRepo.login("my-email", password: "my-password")

        expect(self.fakeHttp.post_args.path).to(equal("/session"))
        expect(self.fakeHttp.post_args.parameters["email"] as? String).to(equal("my-email"))
        expect(self.fakeHttp.post_args.parameters["password"] as? String).to(equal("my-password"))


        promise.success([
            "email" : "my-email",
            "id" : 1,
            "token" : "my-token",
            "name": "Danny"]
        )
        NSRunLoop.osu_advance()


        expect(authenticatedUser.value!.token).to(equal("my-token"))
        expect(authenticatedUser.value!.id).to(equal(1))
        expect(authenticatedUser.value!.email).to(equal("my-email"))
        expect(authenticatedUser.value!.name).to(equal("Danny"))
    }

    func test_login_returnsPostFailedErrorWhenLoginTokenIsAbsent() {
        let promise = Promise<[String: AnyObject], RepoError>()
        fakeHttp.post_returnValue = promise.future

        let loginResultFuture = userRepo.login("invalid-email", password: "invalid-password")

        expect(self.fakeHttp.post_args.path).to(equal("/session"))
        expect(self.fakeHttp.post_args.parameters["email"] as? String).to(equal("invalid-email"))
        expect(self.fakeHttp.post_args.parameters["password"] as? String).to(equal("invalid-password"))

        promise.success(["error": "Invalid email or password."])
        NSRunLoop.osu_advance()
        expect(loginResultFuture.error).to(equal(RepoError.PostFailed));
    }

    func test_getMyPosts_delegatesToRestaurantRepo() {
        userRepo.getMyPosts()

        expect(self.fakeHttp.get_args.path).to(equal("/profile/posts"))
    }

    func test_getMyLikes_delegatesToRestaurantRepo() {
        userRepo.getMyLikes()

        expect(self.fakeHttp.get_args.path).to(equal("/profile/likes"))
    }
}
