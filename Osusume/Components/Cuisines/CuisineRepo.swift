import BrightFutures

protocol CuisineRepo {
    func getAll() -> Future<[Cuisine], RepoError>
    func create(cuisine: NewCuisine) -> Future<Cuisine, RepoError>
}
