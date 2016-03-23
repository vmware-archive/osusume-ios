import BrightFutures
@testable import Osusume

class FakeCuisineRepo: CuisineRepo {
    var getAll_returnValue = Future<[Cuisine], RepoError>()
    func getAll() -> Future<[Cuisine], RepoError> {
        return getAll_returnValue
    }

    var create_wasCalled = false
    var create_arg = NewCuisine(name: "")
    var create_returnValue = Future<Cuisine, RepoError>()
    func create(cuisine: NewCuisine) -> Future<Cuisine, RepoError> {
        create_arg = cuisine
        create_wasCalled = true

        return create_returnValue
    }
}
