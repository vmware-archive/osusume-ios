import XCTest
import Nimble
@testable import Osusume

class NetworkPostRepoTest: XCTestCase {
    let fakeRestaurantRepo = FakeRestaurantRepo()
    var networkPostRepo: NetworkPostRepo!

    override func setUp() {
        networkPostRepo = NetworkPostRepo(restaurantRepo: fakeRestaurantRepo)
    }

    func test_getAll_delegatesToRestaurantRepo() {
        networkPostRepo.getAll()

        expect(self.fakeRestaurantRepo.getAll_wasCalled).to(equal(true))
    }
}