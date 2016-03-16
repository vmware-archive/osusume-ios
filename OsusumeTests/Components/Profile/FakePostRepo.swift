import Foundation
import BrightFutures
@testable import Osusume

class FakePostRepo: PostRepo {
    var getAll_wasCalled = false
    var getAll_returnValue = Future<[Restaurant], RepoError>()
    func getAll() -> Future<[Restaurant], RepoError> {
        getAll_wasCalled = true
        return getAll_returnValue
    }
}