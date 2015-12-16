import BrightFutures
import Alamofire
import SwiftyJSON

class RestaurantRepo : Repo {
    func getAll() -> Future<[Restaurant], RepoError> {
        let promise = Promise<[Restaurant], RepoError>()

        Alamofire.request(.GET, "http://osusume.cfapps.io/restaurants")
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let maybeArr: [JSON]? = JSON(value).array

                        if let realJsonRests = maybeArr {
                            let restaurantArray: [Restaurant] = realJsonRests.map { (restaurant: JSON) in
                                if let name = restaurant["name"].string {
                                    return Restaurant(name: name)
                                }

                                return Restaurant(name: "had problem")
                            }

                            promise.success(restaurantArray)
                        }

                    } else {
                        promise.failure(RepoError.Sorry)
                    }
                case .Failure(let error):
                    print(error)
                }
        }



        return promise.future
    }
}
