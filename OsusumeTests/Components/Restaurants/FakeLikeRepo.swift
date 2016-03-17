import BrightFutures
@testable import Osusume

class FakeLikeRepo: LikeRepo {
    var like_wasCalled = false
    var like_arg = 0
    var like_returnValue = Future<Like, LikeRepoError>()
    func like(id: Int) -> Future<Like, LikeRepoError> {
        like_wasCalled = true
        like_arg = id
        return like_returnValue
    }
}