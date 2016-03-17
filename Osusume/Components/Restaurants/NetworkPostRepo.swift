import BrightFutures
import Alamofire

struct NetworkPostRepo: PostRepo {
    let restaurantRepo: RestaurantRepo

    init(restaurantRepo: RestaurantRepo) {
        self.restaurantRepo = restaurantRepo
    }

    func getAll() -> Future<[Restaurant], RepoError> {
        return restaurantRepo.getAll()
    }
}
