import BrightFutures

protocol PostRepo {
    func getAll() -> Future<[Restaurant], RepoError>
}