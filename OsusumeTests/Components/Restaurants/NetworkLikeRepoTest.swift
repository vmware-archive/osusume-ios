import XCTest
import Nimble
@testable import Osusume

class NetworkLikeRepoTest: XCTestCase {

    func test_like_passesCorrectPathToHttp() {
        let fakeHttp = FakeHttp()
        let fakeSessionRepo = FakeSessionRepo()
        fakeSessionRepo.tokenValue = "Valid Token"
        let repo = NetworkLikeRepo(http: fakeHttp)


        repo.like(123)


        expect(fakeHttp.post_args.path).to(equal("/restaurants/123/likes"))
    }
}
