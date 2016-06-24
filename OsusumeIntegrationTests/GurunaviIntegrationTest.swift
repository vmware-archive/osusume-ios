import XCTest
import BrightFutures
import Nimble
@testable import Osusume

class GurunaviIntegrationTest: XCTestCase {

    func test_query_returnsSearchResults() {
        let gnaviRestaurantSearchRepo: GNaviRestaurantSearchRepo = GNaviRestaurantSearchRepo(
            http: DefaultHttp(basePath: ""),
            parser: GNaviRestaurantListParser()
        )


        let result: Future<[SearchResultRestaurant], RepoError> = gnaviRestaurantSearchRepo.getForSearchTerm("すしざんまい")
        NSRunLoop.osu_advance(by: 5)


        let restaurant: SearchResultRestaurant? = result.value?.first
        expect(restaurant?.name).to(contain("すしざんまい"))
        expect(restaurant?.address).toNot(beNil())
    }

}
