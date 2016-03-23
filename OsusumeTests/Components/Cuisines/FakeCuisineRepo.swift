import BrightFutures
@testable import Osusume

class FakeCuisineRepo: CuisineRepo {
    var getAll_returnValue = Future<[Cuisine], RepoError>()
    func getAll() -> Future<[Cuisine], RepoError> {
        return getAll_returnValue
    }
}
