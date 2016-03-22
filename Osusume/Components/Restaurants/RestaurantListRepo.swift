import BrightFutures

protocol RestaurantListRepo {
    func getAll(endpoint: String) -> Future<[Restaurant], RepoError>
}

struct NetworkRestaurantListRepo: RestaurantListRepo {
    private let http: Http
    private let parser: RestaurantParser

    init(http: Http, parser: RestaurantParser) {
        self.http = http
        self.parser = parser
    }

    func getAll(endpoint: String) -> Future<[Restaurant], RepoError> {
        return http
            .get(endpoint, headers: [:])
            .map { value in
                self.parser
                    .parseList(value as! [[String: AnyObject]]).value!
            }
    }
}
