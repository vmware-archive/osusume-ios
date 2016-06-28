import BrightFutures

protocol RestaurantSearchRepo {
    func getForSearchTerm(term: String) -> Future<[RestaurantSuggestion], RepoError>
}