import XCTest
import BrightFutures

@testable import Osusume

class NetworkRestaurantRepoTest: XCTestCase {
    let fakeHttp = FakeHttp()
    let fakeSessionRepo = FakeSessionRepo()
    var networkRestaurantRepo: NetworkRestaurantRepo!

    override func setUp() {
        let restaurantListRepo = NetworkRestaurantListRepo(
            http: fakeHttp,
            parser: RestaurantParser()
        )

        networkRestaurantRepo = NetworkRestaurantRepo(
            http: fakeHttp,
            restaurantListRepo: restaurantListRepo
        )
    }

    func test_getAll_hitsExpectedEndpoint() {
        networkRestaurantRepo.getAll()


        XCTAssertEqual("/restaurants", fakeHttp.get_args.path)
    }

    func test_getOne_hitsExpectedEndpoint() {
        networkRestaurantRepo.getOne(999)


        XCTAssertEqual("/restaurants/999", fakeHttp.get_args.path)
    }

    func test_create_formatsBodyWithRestaurantData() {
        networkRestaurantRepo.create(
            NewRestaurant(
                name: "Danny's Diner",
                address: "123 Main Street",
                cuisineType: "Creole",
                cuisineId: 9,
                priceRangeId: 1,
                notes: "So good",
                photoUrls: ["my-cool-url", "my-awesome-url"]
            )
        )

        let actualRestaurantParams = fakeHttp.post_args.parameters["restaurant"]!

        XCTAssertEqual("/restaurants", fakeHttp.post_args.path)
        XCTAssertEqual("Danny's Diner", actualRestaurantParams["name"])
        XCTAssertEqual("123 Main Street", actualRestaurantParams["address"])
        XCTAssertEqual("Creole", actualRestaurantParams["cuisine_type"])
        XCTAssertEqual(9, actualRestaurantParams["cuisine_id"])
        XCTAssertEqual(1, actualRestaurantParams["price_range_id"])
        XCTAssertEqual("So good", actualRestaurantParams["notes"])
        XCTAssertEqual([["url": "my-cool-url"], ["url": "my-awesome-url"]], actualRestaurantParams["photo_urls"])
    }

    func test_update() {
        networkRestaurantRepo.update(999, params: ["paramName" : "paramValue"])

        XCTAssertEqual("/restaurants/999", fakeHttp.patch_args.path)
    }
}
