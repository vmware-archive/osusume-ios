import Result
import BrightFutures

struct NetworkRestaurantSearchRepo: RestaurantSearchRepo {
    let http: Http
    let parser: RestaurantSuggestionListParser

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
                    .parseGNaviResponse(json)
                    .mapError {
                        _ in return RepoError.PostFailed
                    }
            }
    }
}