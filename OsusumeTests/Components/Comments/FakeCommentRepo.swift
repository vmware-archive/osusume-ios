import BrightFutures
@testable import Osusume

class FakeCommentRepo: CommentRepo {
    private(set) var persist_wasCalled = false
    private(set) var persist_arg = NewComment(
        text: "FAKE: I park my car in Harvard yard.",
        restaurantId: 0
    )

    var persist_returnValue = Future<PersistedComment, RepoError>()

    func persist(comment: NewComment) -> Future<PersistedComment, RepoError> {
        persist_wasCalled = true
        persist_arg = comment

        return persist_returnValue
    }
}
