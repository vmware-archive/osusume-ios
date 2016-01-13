import BrightFutures
import Alamofire

class HttpRestaurantRepo : RestaurantRepo {
    var converter: RestaurantConverter = RestaurantConverter()

    static let basePath = NSBundle.mainBundle().objectForInfoDictionaryKey("ServerURL") as! String

    let path = "\(basePath)/restaurants"

    func getAll() -> Future<[Restaurant], RepoError> {
        let promise = Promise<[Restaurant], RepoError>()

        Alamofire.request(.GET, path)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        promise.success(self.converter.perform(value as! NSArray as? [NSDictionary]))
                    } else {
                        promise.failure(RepoError.GetFailed)
                    }
                case .Failure(let error):
                    promise.failure(RepoError.GetFailed)
                }
        }

        return promise.future
    }

    func create(params: [String: AnyObject]) -> Future<String, RepoError> {
        let promise = Promise<String, RepoError>()
        let restaurantParams = ["restaurant": params]
        Alamofire.request(.POST, path, parameters: restaurantParams)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    promise.success("OK")
                case .Failure(let error):
                    promise.failure(RepoError.PostFailed)
                }
        }
        return promise.future
    }

    func getOne(id: Int) -> Future<Restaurant, RepoError> {
        let promise = Promise<Restaurant, RepoError>()

        let memberPath = "\(path)/\(id)"
        Alamofire.request(.GET, memberPath)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        promise.success(self.converter.perform(value as! NSDictionary))
                    } else {
                        promise.failure(RepoError.GetFailed)
                    }
                case .Failure(let _):
                    promise.failure(RepoError.GetFailed)
                }

        }
    return promise.future
    }

    func update(id: Int, params: [String: AnyObject]) -> Future<String, RepoError> {
        let promise = Promise<String, RepoError>()
        let memberPath = "\(path)/\(id)"
        let restaurantParams = ["restaurant": params]
        Alamofire.request(.PATCH, memberPath, parameters: restaurantParams)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    promise.success("OK")
                case .Failure(let error):
                    promise.failure(RepoError.PostFailed)
                }
        }
        return promise.future
    }


}
