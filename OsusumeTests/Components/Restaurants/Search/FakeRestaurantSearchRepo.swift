import BrightFutures
@testable import Osusume

class FakeRestaurantSearchRepo: RestaurantSearchRepo {
    var getForSearchTerm_wasCalled = false
    var getForSearchTerm_returnValue = Future<[RestaurantSuggestion], RepoError>()
    func getForSearchTerm(term: String) -> Future<[RestaurantSuggestion], RepoError> {
        getForSearchTerm_wasCalled = true
        return getForSearchTerm_returnValue
    }
}
