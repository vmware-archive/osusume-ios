import BrightFutures
@testable import Osusume

class FakeUserRepo : UserRepo {
    var login_returnValue = Future<AuthenticatedUser, RepoError>()
    var login_args = (email: "", password: "")
    func login(email : String, password: String) -> Future<AuthenticatedUser, RepoError> {
        login_args.email = email
        login_args.password = password
        return login_returnValue
    }

    var fetchCurrentUserId_returnValue = Future<Int, RepoError>()
    func fetchCurrentUserId() -> Future<Int, RepoError> {
        return fetchCurrentUserId_returnValue
    }

    var getMyPosts_returnValue = Future<[Restaurant], RepoError>()
    func getMyPosts() -> Future<[Restaurant], RepoError> {
        return getMyPosts_returnValue
    }

    var getMyLikes_returnValue = Future<[Restaurant], RepoError>()
    func getMyLikes() -> Future<[Restaurant], RepoError> {
        return getMyLikes_returnValue
    }
}
