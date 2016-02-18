import BrightFutures

protocol RestaurantRepo : class {
    func getAll() -> Future<[Restaurant], RepoError>

    func getOne(id: Int) -> Future<Restaurant, RepoError>

    func create(restaurantForm: NewRestaurant) -> Future<HttpJson, RepoError>

    func update(id: Int, params: [String: AnyObject]) -> Future<HttpJson, RepoError>
}