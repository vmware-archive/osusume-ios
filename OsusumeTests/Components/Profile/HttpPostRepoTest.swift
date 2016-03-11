import XCTest
import Nimble
@testable import Osusume

class HttpPostRepoTest: XCTestCase {
    let fakeHttp = FakeHttp()
    let fakeSessionRepo = FakeSessionRepo()
    var httpPostRepo: HttpPostRepo!

    override func setUp() {
        fakeSessionRepo.tokenValue = "some-session-token"

        httpPostRepo = HttpPostRepo(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo
        )
    }

    func test_getAll_passesTokenAsHeaderToHttp() {
        httpPostRepo.getAll()

        let expectedHeaders = [
            "Authorization": "Bearer some-session-token"
        ]

        XCTAssertEqual("/profile/posts", fakeHttp.get_args.path)
        XCTAssertEqual(expectedHeaders, fakeHttp.get_args.headers)
    }
}