@testable import Osusume

class FakeLikeRepo: LikeRepo {
    var like_wasCalled = false
    var like_arg = 0
    func like(id: Int) {
        like_wasCalled = true
        like_arg = id
    }
}