import XCTest
import Nimble
@testable import Osusume

class NetworkPostRepoTest: XCTestCase {
    let fakeHttp = FakeHttp()
    var networkPostRepo: NetworkPostRepo!

    override func setUp() {
        let restaurantListRepo = NetworkRestaurantListRepo(http: fakeHttp, parser: RestaurantParser())
        networkPostRepo = NetworkPostRepo(restaurantListRepo: restaurantListRepo)
    }

    func test_getAll_delegatesToRestaurantRepo() {
        networkPostRepo.getAll()

        expect(self.fakeHttp.get_args.path).to(equal("/profile/posts"))
    }
}
