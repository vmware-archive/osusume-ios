import BrightFutures

struct NetworkLikeRepo: LikeRepo {
    let http: Http

    func setRestaurantLiked(restaurantId: Int, liked: Bool) -> Future<Like, LikeRepoError> {
        if (liked) {
            return like(restaurantId)
        }

        return unlike(restaurantId)
    }

    // MARK: - Private Methods
    private func like(restaurantId: Int) -> Future<Like, LikeRepoError> {
        let path = buildPath(restaurantId)
        return http.post(
            path,
            headers: [:],
            parameters: [:]
        )
            .mapError { _ in LikeRepoError.LikeFailed }
            .map { _ in Like() }
    }

    private func unlike(restaurantId: Int) -> Future<Like, LikeRepoError> {
        let path = buildPath(restaurantId)
        return http.delete(
            path,
            headers: [:]
        )
            .mapError { _ in LikeRepoError.LikeFailed }
            .map { _ in Like() }
    }

    private func buildPath(restaurantId: Int) -> String {
        return "/restaurants/\(restaurantId)/likes"
    }
}
