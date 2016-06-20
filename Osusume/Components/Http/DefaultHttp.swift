import BrightFutures

struct DefaultHttp: Http {
    let basePath: String

    init(basePath: String) {
        self.basePath = basePath
    }

    func get(
        path: String,
        headers: [String : String]
        ) -> Future<AnyObject, RepoError>
    {
        let promise = Promise<AnyObject, RepoError>()

        request("GET", path: path, headers: headers).responseJSON { result in
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
        headers: [String : String],
        parameters: [String : AnyObject]
        ) -> Future<[String : AnyObject], RepoError>
    {
        let promise = Promise<[String : AnyObject], RepoError>()

        request("POST", path: path, headers: headers, parameters: parameters).responseJSON { result in
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
        headers: [String : String],
        parameters: [String : AnyObject]
        ) -> Future<[String : AnyObject], RepoError>
    {
        let promise = Promise<[String: AnyObject], RepoError>()

        request("PATCH", path: path, headers: headers, parameters: parameters).responseJSON { result in
            switch result {
                case .Success:
                    promise.success(["status" : "OK"])
                case .Failure(_):
                    promise.failure(RepoError.PatchFailed)
            }
        }

        return promise.future
    }

    func delete(
        path: String,
        headers: [String : String],
        parameters: [String : AnyObject]
        ) -> Future<[String : AnyObject], RepoError>
    {
        let promise = Promise<[String: AnyObject], RepoError>()

        request("DELETE", path: path, headers: headers, parameters: parameters).responseJSON { result in
            switch result {
            case .Success:
                promise.success(["status" : "OK"])
            case .Failure:
                promise.failure(RepoError.DeleteFailed)
            }
        }

        return promise.future
    }

    // MARK: - Private Methods
    private func request(
        httpMethod: String,
        path: String,
        headers: [String : String],
        parameters: [String : AnyObject] = [:]
        ) -> NSURLRequest
    {
        let URL = NSURL(string: "\(basePath)\(path)")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = httpMethod

        if let bearerToken = headers["Authorization"] {
            mutableURLRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        }

        if (httpMethod == "POST" || httpMethod == "PATCH" || httpMethod == "DELETE") {
            if let body = try? NSJSONSerialization.dataWithJSONObject(
                parameters,
                options: NSJSONWritingOptions())
            {
                mutableURLRequest.HTTPBody = body
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        return mutableURLRequest.copy() as! NSURLRequest
    }
}
