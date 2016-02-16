import BrightFutures

typealias HttpJson = [String: AnyObject]

protocol Http {
    func get(
        path: String,
        headers: [String: String]) -> Future<AnyObject, RepoError>

    func post(
        path: String,
        headers: [String: String],
        parameters: [String: AnyObject]) -> Future<HttpJson, RepoError>

    func patch(
        path: String,
        headers: [String: String],
        parameters: [String: AnyObject]) -> Future<HttpJson, RepoError>
}