import XCTest
import Nimble
@testable import Osusume

class NetworkLikeRepoTest: XCTestCase {

    func test_like_passesCorrectPathToHttp() {
        let fakeHttp = FakeHttp()
        let fakeSessionRepo = FakeSessionRepo()
        fakeSessionRepo.tokenValue = "Valid Token"
        let repo = NetworkLikeRepo(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo
        )


        repo.like(123)


        let expectedHeaders = [
            "Authorization": "Bearer Valid Token"
        ]
        expect(fakeHttp.post_args.path).to(equal("/restaurants/123/likes"))
        expect(fakeHttp.post_args.headers).to(equal(expectedHeaders))
    }
}
