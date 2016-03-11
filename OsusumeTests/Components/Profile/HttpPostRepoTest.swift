import XCTest
import Nimble
@testable import Osusume

class HttpPostRepoTest: XCTestCase {
    let fakeRestaurantRepo = FakeRestaurantRepo()
    var httpPostRepo: HttpPostRepo!

    override func setUp() {
        httpPostRepo = HttpPostRepo(restaurantRepo: fakeRestaurantRepo)
    }

    func test_getAll_delegatesToRestaurantRepo() {
        httpPostRepo.getAll()

        expect(self.fakeRestaurantRepo.getAll_wasCalled).to(equal(true))
    }
}