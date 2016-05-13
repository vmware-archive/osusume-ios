import BrightFutures

protocol RestaurantSearchRepo {
    func getForSearchTerm(term: String) -> Future<[SearchResultRestaurant], RepoError>
}