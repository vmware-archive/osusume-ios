import BrightFutures
import Alamofire

class HttpRestaurantRepo : RestaurantRepo {
    var converter: RestaurantConverter = RestaurantConverter()

    let path: String = "/restaurants"
    let http: Http

    init(http: Http) {
        self.http = http
    }

    //MARK: - GET Functions

    func getAll() -> Future<[Restaurant], RepoError> {
        return http.get(path).map { value in
            return self.converter.perform(value as! [HttpJson])
        }
    }

    func getOne(id: Int) -> Future<Restaurant, RepoError> {
        return http.get("\(path)/\(id)").map { value in
            return self.converter.perform(value as! HttpJson)
        }
    }

    //MARK: - POST Functions

    func create(params: [String: AnyObject]) -> Future<HttpJson, RepoError> {
        return http.post(path, parameters: ["restaurant": params])
    }

    //MARK: - PATCH Functions

    func update(id: Int, params: [String: AnyObject]) -> Future<HttpJson, RepoError> {
        return http.patch("\(path)/\(id)", parameters: ["restaurant": params])
    }
}
