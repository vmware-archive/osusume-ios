import BrightFutures

protocol LikedRestaurantRepo {
    func getAll() -> Future<[Restaurant], RepoError>
}
