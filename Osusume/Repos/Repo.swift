import BrightFutures

enum RepoError : ErrorType {
    case Sorry
}

protocol Repo : class {
    func getAll() -> Future<[Restaurant], RepoError>
}