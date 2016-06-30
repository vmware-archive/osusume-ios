import BrightFutures

struct NetworkRestaurantRepo: RestaurantRepo {
    let parser: RestaurantParser
    let path: String
    let http: Http
    private let restaurantListRepo: RestaurantListRepo

    init(http: Http, restaurantListRepo: RestaurantListRepo) {
        self.parser = RestaurantParser()
        self.path = "/restaurants"
        self.http = http
        self.restaurantListRepo = restaurantListRepo
    }

    // MARK: - GET Functions

    func getAll() -> Future<[Restaurant], RepoError> {
        return restaurantListRepo.getAll(path)
    }

    func getOne(id: Int) -> Future<Restaurant, RepoError> {
        return http
            .get("\(path)/\(id)", headers: [:])
            .map { value in
                self.parser
                    .parseSingle(value as! [String: AnyObject]).value!
        }
    }

    // MARK: - POST Functions

    func create(newRestaurant: NewRestaurant) -> Future<AnyObject, RepoError> {
        return http
            .post(
                path,
                headers: [:],
                parameters: [
                    "restaurant": [
                        "name": newRestaurant.name,
                        "address": newRestaurant.address,
                        "cuisine_type": newRestaurant.cuisine?.name ?? "",
                        "cuisine_id": newRestaurant.cuisine?.id ?? 0,
                        "price_range_id": newRestaurant.priceRange?.id ?? 0,
                        "notes": newRestaurant.notes,
                        "photo_urls": newRestaurant.photoUrls.map { url in ["url": url] }
                    ]
                ]
            )
    }

    // MARK: - PATCH Functions

    func update(id: Int, params: [String: AnyObject]) -> Future<[String: AnyObject], RepoError> {
        let name = params["name"] as! String
        let address = params["address"] as! String
        let cuisine_type = params["cuisine_type"] as? String ?? ""
        let cuisine_id = params["cuisine_id"] as? Int ?? 0
        let price_range_id = params["price_range_id"] as? Int ?? 0
        let notes = params["notes"] as! String
        let photos = params["photo_urls"] as? [AnyObject] ?? []
        let photo_urls = photos.map { url in ["url": url] }
        let updatedParams = ["restaurant": [
            "name": name,
            "address": address,
            "cuisine_type": cuisine_type,
            "cuisine_id": cuisine_id,
            "price_range_id": price_range_id,
            "notes": notes,
            "photo_urls": photo_urls
        ]]
        return http
            .patch(
                "\(path)/\(id)",
                headers: [:],
                parameters: updatedParams
            )
    }
}
