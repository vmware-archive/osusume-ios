import BrightFutures

protocol CommentRepo {
    func persist(comment: NewComment) -> Future<PersistedComment, RepoError>
}

struct HttpCommentRepo: CommentRepo {
    let http: Http

    func persist(comment: NewComment) -> Future<PersistedComment, RepoError> {
        return Future<PersistedComment, RepoError>()
    }
}
