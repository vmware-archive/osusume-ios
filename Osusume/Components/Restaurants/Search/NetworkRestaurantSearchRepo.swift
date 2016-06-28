import Result
import BrightFutures

struct NetworkRestaurantSearchRepo <P: DataParser where P.ParsedObject == [RestaurantSuggestion]>: RestaurantSearchRepo {
    let http: Http
    let parser: P

    func getForSearchTerm(term: String) -> Future<[RestaurantSuggestion], RepoError> {
        let path = "/restaurant_suggestions"
        return http
            .post(
                path,
                headers: [:],
                parameters: ["restaurantName" : term]
            )
            .flatMap { json in
                return self.parser
                    .parse(json)
                    .mapError {
                        _ in return RepoError.PostFailed
                    }
            }
    }
}