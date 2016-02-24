import BrightFutures

protocol CommentRepo {
    func persist(comment: NewComment) -> Future<PersistedComment, RepoError>
}

struct HttpCommentRepo <P: DataParser where P.ParsedObject == PersistedComment>: CommentRepo {
    let http: Http
    let sessionRepo: SessionRepo
    let parser: P

    func persist(comment: NewComment) -> Future<PersistedComment, RepoError> {
        let path = "/restaurants/\(comment.restaurantId)/comments"

        return http
            .post(
                path,
                headers: buildHeaders(),
                parameters: ["comment": ["content": comment.text]]
            )
            .mapError { _ in
                return RepoError.PostFailed
            }
            .flatMap { httpJson in
                return self.parser
                    .parse(httpJson)
                    .mapError { _ in return RepoError.ParsingFailed }
            }
    }

    private func buildHeaders() -> [String: String] {
        return [
            "Authorization": "Bearer \(sessionRepo.getToken()!)"
        ]
    }
}
