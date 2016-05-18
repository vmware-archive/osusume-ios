@testable import Osusume
import BrightFutures

class FakePriceRangeRepo: PriceRangeRepo {
    var getAll_wasCalled = false
    var getAll_returnValue = Future<[PriceRange], RepoError>()
    func getAll() -> Future<[PriceRange], RepoError> {
        getAll_wasCalled = true
        return getAll_returnValue
    }
}
