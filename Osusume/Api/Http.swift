import BrightFutures

typealias HttpJson = [String: AnyObject]

protocol Http {
    func get(path: String) -> Future<AnyObject, RepoError>

    func post(path: String, parameters: [String: AnyObject]) -> Future<HttpJson, RepoError>

    func patch(path: String, parameters: [String: AnyObject]) -> Future<HttpJson, RepoError>
}