import BrightFutures

protocol RestaurantRepo {
    func getAll() -> Future<[Restaurant], RepoError>

    func getOne(id: Int) -> Future<Restaurant, RepoError>

    func create(restaurantForm: NewRestaurant) -> Future<AnyObject, RepoError>

    func update(id: Int, params: [String: AnyObject]) -> Future<[String: AnyObject], RepoError>
}
