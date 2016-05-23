import BrightFutures
@testable import Osusume

class FakeLikeRepo: LikeRepo {
    private(set) var setRestaurantLiked_wasCalled = false
    private(set) var setRestaurantLiked_args = (restaurantId: 0, liked: false)
    var setRestaurantLiked_returnValue = Future<Like, LikeRepoError>()
    func setRestaurantLiked(restaurantId: Int, liked: Bool) -> Future<Like, LikeRepoError> {
        setRestaurantLiked_wasCalled = true
        setRestaurantLiked_args = (restaurantId: restaurantId, liked: liked)
        return setRestaurantLiked_returnValue
    }
}