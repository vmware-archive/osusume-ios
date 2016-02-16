import XCTest

@testable import Osusume

class HttpRestaurantRepoTest: XCTestCase {
    let fakeHttp = FakeHttp()
    let fakeSessionRepo = FakeSessionRepo()
    var httpRestaurantRepo: HttpRestaurantRepo!

    override func setUp() {
        fakeSessionRepo.tokenValue = "some-session-token"

        httpRestaurantRepo = HttpRestaurantRepo(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo
        )
    }

    func test_getAll_passesTokenAsHeaderToHttp() {
        httpRestaurantRepo.getAll()

        let expectedHeaders = [
            "Authorization": "Bearer some-session-token"
        ]

        XCTAssertEqual("/restaurants", fakeHttp.get_args.path)
        XCTAssertEqual(expectedHeaders, fakeHttp.get_args.headers)
    }

    func test_getOne_passesTokenAsHeaderToHttp() {
        httpRestaurantRepo.getOne(999)

        let expectedHeaders = [
            "Authorization": "Bearer some-session-token"
        ]

        XCTAssertEqual("/restaurants/999", fakeHttp.get_args.path)
        XCTAssertEqual(expectedHeaders, fakeHttp.get_args.headers)
    }

    func test_create_passesTokenAsHeaderToHttp() {
        httpRestaurantRepo.create(["paramName": "paramValue"])

        let expectedHeaders = [
            "Authorization": "Bearer some-session-token"
        ]

        XCTAssertEqual("/restaurants", fakeHttp.post_args.path)
        XCTAssertEqual(expectedHeaders, fakeHttp.post_args.headers)
    }

    func test_update_passesTokenAsHeaderToHttp() {
        httpRestaurantRepo.update(999, params: ["paramName": "paramValue"])

        let expectedHeaders = [
            "Authorization": "Bearer some-session-token"
        ]

        XCTAssertEqual("/restaurants/999", fakeHttp.patch_args.path)
        XCTAssertEqual(expectedHeaders, fakeHttp.patch_args.headers)
    }
}
