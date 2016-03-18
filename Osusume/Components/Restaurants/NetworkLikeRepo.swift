import BrightFutures

struct NetworkLikeRepo: LikeRepo {
    let http: Http
    let sessionRepo: SessionRepo

    func like(id: Int) -> Future<Like, LikeRepoError> {
        let headers = [
            "Authorization": "Bearer \(sessionRepo.getToken()!)"
        ]

        return http.post(
            "/restaurants/\(id)/likes",
            headers: headers,
            parameters: [:]
        )
            .mapError { _ in LikeRepoError.LikeFailed }
            .map { _ in Like() }
    }
}
