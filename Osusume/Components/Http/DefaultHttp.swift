import BrightFutures
import Alamofire

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

        request(.POST, path: path, headers: headers, parameters: parameters).responseJSON { response in
            switch response.result {
            case .Success:
                promise.success(response.result.value as! [String: AnyObject])
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

        request(.PATCH, path: path, headers: headers, parameters: parameters).responseJSON { response in
            switch response.result {
            case .Success:
                promise.success(["status": "OK"])
            case .Failure(_):
                promise.failure(RepoError.PatchFailed)
            }
        }

        return promise.future
    }

    // MARK: - Private Methods
    private func request(
        method: Alamofire.Method,
        path: String,
        headers: [String: String],
        parameters: [String: AnyObject] = [:]
        ) -> Request
    {
        let URL = NSURL(string: "\(basePath)\(path)")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = method.rawValue

        if let bearerToken = headers["Authorization"] {
            mutableURLRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        }

        do {
            if (method != .GET) {
                mutableURLRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(
                    parameters,
                    options: NSJSONWritingOptions()
                )
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            // No-op
        }

        return Alamofire.request(mutableURLRequest)
    }

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
}
