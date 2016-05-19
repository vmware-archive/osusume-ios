import BrightFutures

struct SessionHttp: Http {
    private let http: Http
    private let sessionRepo: SessionRepo

    init(http: Http, sessionRepo: SessionRepo) {
        self.http = http
        self.sessionRepo = sessionRepo
    }

    func get(
        path: String,
        headers: [String : String]
        ) -> Future<AnyObject, RepoError>
    {
        return http.get(path, headers: addAuthToken(headers))
    }

    func post(
        path: String,
        headers: [String : String],
        parameters: [String : AnyObject]
        ) -> Future<[String : AnyObject], RepoError>
    {
        return http.post(path, headers: addAuthToken(headers), parameters: parameters)
    }

    func patch(
        path: String,
        headers: [String : String],
        parameters: [String : AnyObject]
        ) -> Future<[String : AnyObject], RepoError>
    {
        return http.patch(path, headers: addAuthToken(headers), parameters: parameters)
    }

    func delete(path: String, headers: [String : String], parameters: [String : AnyObject]) -> Future<[String : AnyObject], RepoError> {
        return Future<[String : AnyObject], RepoError>()
    }

    // MARK: - Private Methods
    private func addAuthToken(
        headers: [String : String]
        ) -> [String : String]
    {
        var headersWithAuthorization = headers

        if let token = sessionRepo.getAuthenticatedUser()?.token {
            headersWithAuthorization["Authorization"] = "Bearer \(token)"
        }

        return headersWithAuthorization
    }
}
