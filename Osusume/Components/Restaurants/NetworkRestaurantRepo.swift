import BrightFutures
import Alamofire

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

    func create(newRestaurant: NewRestaurant) -> Future<[String: AnyObject], RepoError> {
        return http
            .post(
                path,
                headers: [:],
                parameters: [
                    "restaurant": [
                        "name": newRestaurant.name,
                        "address": newRestaurant.address,
                        "cuisine_type": newRestaurant.cuisineType,
                        "cuisine_id": newRestaurant.cuisineId,
                        "offers_english_menu": newRestaurant.offersEnglishMenu,
                        "walk_ins_ok": newRestaurant.walkInsOk,
                        "accepts_credit_cards": newRestaurant.acceptsCreditCards,
                        "notes": newRestaurant.notes,
                        "photo_urls": newRestaurant.photoUrls.map { url in ["url": url] }
                    ]
                ]
            )
    }

    // MARK: - PATCH Functions

    func update(id: Int, params: [String: AnyObject]) -> Future<[String: AnyObject], RepoError> {
        return http
            .patch(
                "\(path)/\(id)",
                headers: [:],
                parameters: ["restaurant": params]
            )
    }
}
