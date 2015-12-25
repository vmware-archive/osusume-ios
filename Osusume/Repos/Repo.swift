import BrightFutures

enum RepoError : ErrorType {
    case GetFailed
    case PostFailed
}

protocol Repo : class {
    func getAll() -> Future<[Restaurant], RepoError>

    func create(params: [String: String]) -> Future<String, RepoError>
}