import BrightFutures

protocol PostRepo {
    func getAll() -> Future<[Restaurant], RepoError>
}

struct NetworkPostRepo: PostRepo {
    private let restaurantListRepo: RestaurantListRepo

    init(restaurantListRepo: RestaurantListRepo) {
        self.restaurantListRepo = restaurantListRepo
    }

    func getAll() -> Future<[Restaurant], RepoError> {
        return restaurantListRepo.getAll("/profile/posts")
    }
}
