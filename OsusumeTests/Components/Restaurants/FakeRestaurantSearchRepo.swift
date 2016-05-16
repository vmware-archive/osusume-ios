import BrightFutures
@testable import Osusume

class FakeRestaurantSearchRepo: RestaurantSearchRepo {
    var getForSearchTerm_wasCalled = false
    var getForSearchTerm_returnValue = Future<[SearchResultRestaurant], RepoError>()
    func getForSearchTerm(term: String) -> Future<[SearchResultRestaurant], RepoError> {
        getForSearchTerm_wasCalled = true
        return getForSearchTerm_returnValue
    }
}
