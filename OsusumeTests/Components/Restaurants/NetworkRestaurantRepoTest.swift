import XCTest

@testable import Osusume

class NetworkRestaurantRepoTest: XCTestCase {
    let fakeHttp = FakeHttp()
    let fakeSessionRepo = FakeSessionRepo()
    var networkRestaurantRepo: NetworkRestaurantRepo!

    override func setUp() {
        fakeSessionRepo.tokenValue = "some-session-token"

        networkRestaurantRepo = NetworkRestaurantRepo(
            http: fakeHttp,
            sessionRepo: fakeSessionRepo
        )
    }

    func test_getAll_passesTokenAsHeaderToHttp() {
        networkRestaurantRepo.getAll()

        let expectedHeaders = [
            "Authorization": "Bearer some-session-token"
        ]

        XCTAssertEqual("/restaurants", fakeHttp.get_args.path)
        XCTAssertEqual(expectedHeaders, fakeHttp.get_args.headers)
    }

    func test_getOne_passesTokenAsHeaderToHttp() {
        networkRestaurantRepo.getOne(999)

        let expectedHeaders = [
            "Authorization": "Bearer some-session-token"
        ]

        XCTAssertEqual("/restaurants/999", fakeHttp.get_args.path)
        XCTAssertEqual(expectedHeaders, fakeHttp.get_args.headers)
    }

    func test_create_formatsBodyWithRestaurantData() {
        networkRestaurantRepo.create(
            NewRestaurant(
                name: "Danny's Diner",
                address: "123 Main Street",
                cuisineType: "Creole",
                offersEnglishMenu: true,
                walkInsOk: true,
                acceptsCreditCards: true,
                notes: "So good",
                photoUrls: ["my-cool-url", "my-awesome-url"]
            )
        )

        let expectedHeaders = ["Authorization": "Bearer some-session-token"]
        let actualRestaurantParams = fakeHttp.post_args.parameters["restaurant"]!

        XCTAssertEqual("/restaurants", fakeHttp.post_args.path)
        XCTAssertEqual(expectedHeaders, fakeHttp.post_args.headers)
        XCTAssertEqual("Danny's Diner", actualRestaurantParams["name"])
        XCTAssertEqual("123 Main Street", actualRestaurantParams["address"])
        XCTAssertEqual("Creole", actualRestaurantParams["cuisine_type"])
        XCTAssertEqual(true, actualRestaurantParams["offers_english_menu"])
        XCTAssertEqual(true, actualRestaurantParams["walk_ins_ok"])
        XCTAssertEqual(true, actualRestaurantParams["accepts_credit_cards"])
        XCTAssertEqual("So good", actualRestaurantParams["notes"])
        XCTAssertEqual([["url": "my-cool-url"], ["url": "my-awesome-url"]], actualRestaurantParams["photo_urls"])
    }

    func test_update_passesTokenAsHeaderToHttp() {
        networkRestaurantRepo.update(999, params: ["paramName": "paramValue"])

        let expectedHeaders = [
            "Authorization": "Bearer some-session-token"
        ]

        XCTAssertEqual("/restaurants/999", fakeHttp.patch_args.path)
        XCTAssertEqual(expectedHeaders, fakeHttp.patch_args.headers)
    }
}
