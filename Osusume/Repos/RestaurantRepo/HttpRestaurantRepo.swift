import BrightFutures
import Alamofire

class HttpRestaurantRepo: RestaurantRepo {
    let converter: RestaurantConverter
    let path: String
    let http: Http
    let sessionRepo: SessionRepo

    init(http: Http, sessionRepo: SessionRepo) {
        self.converter = RestaurantConverter()
        self.path = "/restaurants"
        self.http = http
        self.sessionRepo = sessionRepo
    }

    //MARK: - GET Functions

    func getAll() -> Future<[Restaurant], RepoError> {
        return http
            .get(path, headers: buildHeaders())
            .map { value in self.converter.perform(value as! [HttpJson]) }
    }

    func getOne(id: Int) -> Future<Restaurant, RepoError> {
        return http
            .get("\(path)/\(id)", headers: buildHeaders())
            .map { value in self.converter.perform(value as! HttpJson) }
    }

    //MARK: - POST Functions

    func create(params: [String: AnyObject]) -> Future<HttpJson, RepoError> {
        return http
            .post(
                path,
                headers: buildHeaders(),
                parameters: ["restaurant": params]
            )
    }

    //MARK: - PATCH Functions

    func update(id: Int, params: [String: AnyObject]) -> Future<HttpJson, RepoError> {
        return http
            .patch(
                "\(path)/\(id)",
                headers: buildHeaders(),
                parameters: ["restaurant": params]
            )
    }

    // MARK: - Private Methods
    private func buildHeaders() -> [String: String] {
        return [
            "Authorization": "Bearer \(sessionRepo.getToken()!)"
        ]
    }
}
