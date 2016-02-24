import BrightFutures

protocol Http {
    func get(
        path: String,
        headers: [String: String]) -> Future<AnyObject, RepoError>

    func post(
        path: String,
        headers: [String: String],
        parameters: [String: AnyObject]) -> Future<[String: AnyObject], RepoError>

    func patch(
        path: String,
        headers: [String: String],
        parameters: [String: AnyObject]) -> Future<[String: AnyObject], RepoError>
}