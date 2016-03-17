import BrightFutures

enum LikeRepoError: ErrorType {
    case LikeFailed
}

protocol LikeRepo {
    func like(id: Int) -> Future<Like, LikeRepoError>
}