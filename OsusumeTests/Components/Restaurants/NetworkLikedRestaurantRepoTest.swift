import Nimble
import XCTest
@testable import Osusume

class NetworkLikedRestaurantRepoTest: XCTestCase {
    func test_getAll_delegatesToRestaurantRepo() {
        let fakeHttp = FakeHttp()
        let restaurantListRepo = NetworkRestaurantListRepo(http: fakeHttp, parser: RestaurantParser())
        let likedRestaurantRepo = NetworkLikedRestaurantRepo(restaurantListRepo: restaurantListRepo)


        likedRestaurantRepo.getAll()


        expect(fakeHttp.get_args.path).to(equal("/profile/likes"))
    }
}
