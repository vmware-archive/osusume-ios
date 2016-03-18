import BrightFutures

struct NetworkLikeRepo: LikeRepo {
    let http: Http

    func like(id: Int) -> Future<Like, LikeRepoError> {
        return http.post(
            "/restaurants/\(id)/likes",
            headers: [:],
            parameters: [:]
        )
            .mapError { _ in LikeRepoError.LikeFailed }
            .map { _ in Like() }
    }
}
