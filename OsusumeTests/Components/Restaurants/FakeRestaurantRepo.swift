import BrightFutures
@testable import Osusume

class FakeRestaurantRepo: RestaurantRepo {
    var getAll_wasCalled = false
    var getAll_returnValue = Future<[Restaurant], RepoError>()
    func getAll() -> Future<[Restaurant], RepoError> {
        getAll_wasCalled = true
        return getAll_returnValue
    }

    var create_args : NewRestaurant!
    func create(newRestaurant: NewRestaurant) -> Future<[String: AnyObject], RepoError> {
        let promise = Promise<[String: AnyObject], RepoError>()
        promise.success([String: AnyObject]())

        create_args = newRestaurant

        return promise.future
    }

    var getOne_returnValue = Future<Restaurant, RepoError>()
    func getOne(id: Int) -> Future<Restaurant, RepoError> {
        return getOne_returnValue
    }

    var update_params: [String: AnyObject] = [:]
    func update(id: Int, params: [String: AnyObject]) -> Future<[String: AnyObject], RepoError> {
        let promise = Promise<[String: AnyObject], RepoError>()
        promise.success([String: AnyObject]())

        update_params = params

        return promise.future
    }
}