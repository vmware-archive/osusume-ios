import BrightFutures
@testable import Osusume

class FakeCuisineRepo: CuisineRepo {
    var getAll_returnValue = Future<CuisineList, RepoError>()
    func getAll() -> Future<CuisineList, RepoError> {
        return getAll_returnValue
    }
}
