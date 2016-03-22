import BrightFutures

protocol LikedRestaurantRepo {
    func getAll() -> Future<[Restaurant], RepoError>
}

struct NetworkLikedRestaurantRepo: LikedRestaurantRepo {
    private let restaurantListRepo: RestaurantListRepo

    init(restaurantListRepo: RestaurantListRepo) {
        self.restaurantListRepo = restaurantListRepo
    }

    func getAll() -> Future<[Restaurant], RepoError> {
        return restaurantListRepo.getAll("/profile/likes")
    }
}
