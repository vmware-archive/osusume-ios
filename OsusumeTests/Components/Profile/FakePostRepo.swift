import Foundation
import BrightFutures
@testable import Osusume

class FakePostRepo : PostRepo {
    var createdRestaurant : Restaurant? = nil
    var allRestaurants : [Restaurant] = []

    var postsPromise = Promise<[Restaurant], RepoError>()
    func getAll() -> Future<[Restaurant], RepoError> {
        postsPromise.success(allRestaurants)
        return postsPromise.future
    }
}