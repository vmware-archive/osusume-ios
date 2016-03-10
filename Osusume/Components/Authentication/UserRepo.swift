import BrightFutures

protocol UserRepo {
    func login(email: String, password: String) -> Future<String, RepoError>
    func fetchCurrentUserName() -> Future<String, RepoError>
}