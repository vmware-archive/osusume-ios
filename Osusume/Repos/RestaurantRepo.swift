import BrightFutures
import Alamofire

class RestaurantRepo : Repo {
    var converter: RestaurantConverter = RestaurantConverter()

    func getAll() -> Future<[Restaurant], RepoError> {
        let promise = Promise<[Restaurant], RepoError>()

        Alamofire.request(.GET, "http://osusume.cfapps.io/restaurants")
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
}
