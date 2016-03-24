import BrightFutures

protocol CommentRepo {
    func persist(comment: NewComment) -> Future<PersistedComment, RepoError>
}
