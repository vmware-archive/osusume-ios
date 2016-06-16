import BrightFutures

enum LikeRepoError: ErrorType {
    case LikeFailed
}

protocol LikeRepo {
    func setRestaurantLiked(restaurantId: Int, liked: Bool) -> Future<Like, LikeRepoError>
}