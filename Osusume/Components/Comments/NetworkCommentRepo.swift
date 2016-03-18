import BrightFutures

protocol CommentRepo {
    func persist(comment: NewComment) -> Future<PersistedComment, RepoError>
}

struct NetworkCommentRepo <P: DataParser where P.ParsedObject == PersistedComment>: CommentRepo {
    let http: Http
    let parser: P

    func persist(comment: NewComment) -> Future<PersistedComment, RepoError> {
        let path = "/restaurants/\(comment.restaurantId)/comments"

        return http
            .post(
                path,
                headers: [:],
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
}
