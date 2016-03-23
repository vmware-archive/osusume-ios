import BrightFutures
@testable import Osusume

class FakeUserRepo : UserRepo {
    var submittedEmail : String? = nil
    var submittedPassword : String? = nil

    var stringPromise = Promise<String, RepoError>()

    func login(email : String, password: String) -> Future<String, RepoError> {
        stringPromise.success("token-value")

        self.submittedEmail = email
        self.submittedPassword = password

        return stringPromise.future
    }

    func fetchCurrentUserName() -> Future<String, RepoError> {
        return stringPromise.future
    }

    var getMyPosts_wasCalled = false
    var getMyPosts_returnValue = Future<[Restaurant], RepoError>()
    func getMyPosts() -> Future<[Restaurant], RepoError> {
        getMyPosts_wasCalled = true
        return getMyPosts_returnValue
    }

    var getMyLikes_wasCalled = false
    var getMyLikes_returnValue = Future<[Restaurant], RepoError>()
    func getMyLikes() -> Future<[Restaurant], RepoError> {
        getMyLikes_wasCalled = true
        return getMyLikes_returnValue
    }
}
