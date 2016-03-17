import BrightFutures

struct NetworkLikeRepo: LikeRepo {
    func like(id: Int) -> Future<Like, LikeRepoError> {
        return Future<Like, LikeRepoError>()
    }
}
