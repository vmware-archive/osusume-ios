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

    private func addAuthToken(
        headers: [String : String]
        ) -> [String : String]
    {
        var headersWithAuthorization = headers

        headersWithAuthorization["Authorization"] = "Bearer \(sessionRepo.getToken()!)"

        return headersWithAuthorization
    }
}
