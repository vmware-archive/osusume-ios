import BrightFutures
import Alamofire

struct AlamofireHttp: Http {
    let basePath: String
    let sessionRepo: SessionRepo

    init(basePath: String, sessionRepo: SessionRepo) {
        self.basePath = basePath
        self.sessionRepo = sessionRepo
    }

    func get(path: String) -> Future<AnyObject, RepoError> {
        let promise = Promise<AnyObject, RepoError>()

        request(.GET, path: path).responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
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

    func post(path: String, parameters: [String: AnyObject]) -> Future<HttpJson, RepoError> {
        let promise = Promise<HttpJson, RepoError>()

        request(.POST, path: path, parameters: parameters).responseJSON { response in
            switch response.result {
            case .Success:
                promise.success(response.result.value as! HttpJson)
            case .Failure(_):
                promise.failure(RepoError.PostFailed)
            }
        }

        return promise.future
    }

    func patch(path: String, parameters: [String: AnyObject]) -> Future<HttpJson, RepoError> {
        let promise = Promise<HttpJson, RepoError>()

        request(.PATCH, path: path, parameters: parameters).responseJSON { response in
            switch response.result {
            case .Success:
                promise.success(["status": "OK"])
            case .Failure(_):
                promise.failure(RepoError.PatchFailed)
            }
        }

        return promise.future
    }

    private func request(method: Alamofire.Method, path: String) -> Request {
        return request(method, path: path, parameters: [:])
    }

    private func request(method: Alamofire.Method, path: String, parameters: [String: AnyObject]) -> Request {
        let URL = NSURL(string: "\(basePath)\(path)")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = method.rawValue

        if let token = sessionRepo.getToken() {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        do {
            if (method != .GET) {
                mutableURLRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions())
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            // No-op
        }

        return Alamofire.request(mutableURLRequest)
    }
} 