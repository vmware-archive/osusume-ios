import BrightFutures

enum RepoError : ErrorType {
    case GetFailed
}

protocol Repo : class {
    func getAll() -> Future<[Restaurant], RepoError>
}