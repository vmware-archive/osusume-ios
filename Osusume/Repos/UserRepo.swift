import BrightFutures

protocol UserRepo : class {
    func login(email: String, password: String) -> Future<String, RepoError>
}