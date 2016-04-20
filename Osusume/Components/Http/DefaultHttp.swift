import BrightFutures

struct DefaultHttp: Http {
    let basePath: String

    init(basePath: String) {
        self.basePath = basePath
    }

    func get(
        path: String,
        headers: [String: String]
        ) -> Future<AnyObject, RepoError>
    {
        let promise = Promise<AnyObject, RepoError>()

        getRequest(path, headers: headers).responseJSON { result in
            switch result {
            case .Success:
                if let value = result.value {
                    promise.success(value)
                } else {
                    promise.failure(RepoError.GetFailed)
                }
            case .Failure(_):
                promise.failure(RepoError.GetFailed)
            }
        }

        return promise.future
    }

    func post(
        path: String,
        headers: [String: String],
        parameters: [String: AnyObject]
        ) -> Future<[String: AnyObject], RepoError>
    {
        let promise = Promise<[String: AnyObject], RepoError>()

        postRequest("POST", path: path, headers: headers, parameters: parameters).responseJSON { result in
            switch result {
                case .Success:
                    if let value = result.value as? [String: AnyObject] {
                        promise.success(value)
                    } else {
                        promise.failure(RepoError.PostFailed)
                    }
                case .Failure(_):
                    promise.failure(RepoError.PostFailed)
            }
        }

        return promise.future
    }

    func patch(
        path: String,
        headers: [String: String],
        parameters: [String: AnyObject]
        ) -> Future<[String: AnyObject], RepoError>
    {
        let promise = Promise<[String: AnyObject], RepoError>()

        postRequest("PATCH", path: path, headers: headers, parameters: parameters).responseJSON { result in
            switch result {
                case .Success:
                    promise.success(["status": "OK"])
                case .Failure(_):
                    promise.failure(RepoError.PatchFailed)
            }
        }

        return promise.future
    }

    // MARK: - Private Methods
    private func getRequest(
        path: String,
        headers: [String: String],
        parameters: [String: AnyObject] = [:]
        ) -> NSURLRequest
    {
        let URL = NSURL(string: "\(basePath)\(path)")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "GET"

        if let bearerToken = headers["Authorization"] {
            mutableURLRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        }

        return mutableURLRequest.copy() as! NSURLRequest
    }

    private func postRequest(
        httpMethod: String,
        path: String,
        headers: [String: String],
        parameters: [String: AnyObject] = [:]
        ) -> NSURLRequest
    {
        let URL = NSURL(string: "\(basePath)\(path)")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = httpMethod

        if let bearerToken = headers["Authorization"] {
            mutableURLRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        }

        do {
            mutableURLRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(
                parameters,
                options: NSJSONWritingOptions()
            )
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            // No-op
        }

        return mutableURLRequest.copy() as! NSURLRequest
    }
}
