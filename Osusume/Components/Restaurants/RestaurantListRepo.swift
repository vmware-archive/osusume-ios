import BrightFutures

protocol RestaurantListRepo {
    func getAll(endpoint: String) -> Future<[Restaurant], RepoError>
}
