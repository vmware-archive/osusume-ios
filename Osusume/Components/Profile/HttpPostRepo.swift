import BrightFutures
import Alamofire

struct HttpPostRepo: PostRepo {
    let restaurantRepo: RestaurantRepo

    init(restaurantRepo: RestaurantRepo) {
        self.restaurantRepo = restaurantRepo
    }

    //MARK: - GET Functions
    func getAll() -> Future<[Restaurant], RepoError> {
        return restaurantRepo.getAll()
    }
}
