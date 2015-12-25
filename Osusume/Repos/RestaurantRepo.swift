import BrightFutures
import Alamofire

class RestaurantRepo : Repo {
    var converter: RestaurantConverter = RestaurantConverter()

    let basePath = "http://localhost:3000/restaurants"

    func getAll() -> Future<[Restaurant], RepoError> {
        let promise = Promise<[Restaurant], RepoError>()

        Alamofire.request(.GET, basePath)
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

    func create(params: [String: String]) -> Future<String, RepoError> {
        let promise = Promise<String, RepoError>()
        let restaurantParams = ["restaurant": params]
        Alamofire.request(.POST, basePath, parameters: restaurantParams)
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
