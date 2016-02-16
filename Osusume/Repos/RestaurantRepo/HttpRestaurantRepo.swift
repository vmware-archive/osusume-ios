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
        return http
            .get(path, headers: [String: String]())
            .map { value in self.converter.perform(value as! [HttpJson]) }
    }

    func getOne(id: Int) -> Future<Restaurant, RepoError> {
        return http
            .get("\(path)/\(id)", headers: [String: String]())
            .map { value in self.converter.perform(value as! HttpJson) }
    }

    //MARK: - POST Functions

    func create(params: [String: AnyObject]) -> Future<HttpJson, RepoError> {
        return http
            .post(
                path,
                headers: [String: String](),
                parameters: ["restaurant": params]
            )
    }

    //MARK: - PATCH Functions

    func update(id: Int, params: [String: AnyObject]) -> Future<HttpJson, RepoError> {
        return http
            .patch(
                "\(path)/\(id)",
                headers: [String: String](),
                parameters: ["restaurant": params]
            )
    }
}
