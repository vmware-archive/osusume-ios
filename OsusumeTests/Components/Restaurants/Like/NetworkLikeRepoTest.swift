import XCTest
import Nimble
@testable import Osusume

class NetworkLikeRepoTest: XCTestCase {

    func test_like_passesCorrectPathToHttp() {
        let fakeHttp = FakeHttp()
        let repo = NetworkLikeRepo(http: fakeHttp)


        repo.setRestaurantLiked(123, liked: true)


        expect(fakeHttp.post_args.path).to(equal("/restaurants/123/likes"))
    }

    func test_unlike_passesCorrectPathToHttp() {
        let fakeHttp = FakeHttp()
        let repo = NetworkLikeRepo(http: fakeHttp)


        repo.setRestaurantLiked(456, liked: false)


        expect(fakeHttp.delete_args.path).to(equal("/restaurants/456/likes"))
    }

}
