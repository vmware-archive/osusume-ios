import BrightFutures
import Alamofire

class HttpRestaurantRepo: RestaurantRepo {
    let converter: RestaurantConverter
    let path: String
    let http: Http
    let sessionRepo: SessionRepo

    init(http: Http, sessionRepo: SessionRepo) {
        self.converter = RestaurantConverter()
        self.path = "/restaurants"
        self.http = http
        self.sessionRepo = sessionRepo
    }

    //MARK: - GET Functions

    func getAll() -> Future<[Restaurant], RepoError> {
        return http
            .get(path, headers: buildHeaders())
            .map { value in self.converter.perform(value as! [HttpJson]) }
    }

    func getOne(id: Int) -> Future<Restaurant, RepoError> {
        return http
            .get("\(path)/\(id)", headers: buildHeaders())
            .map { value in self.converter.perform(value as! HttpJson) }
    }

    //MARK: - POST Functions

    func create(newRestaurant: NewRestaurant) -> Future<HttpJson, RepoError> {
        return http
            .post(
                path,
                headers: buildHeaders(),
                parameters: [
                    "restaurant": [
                        "name": newRestaurant.name,
                        "address": newRestaurant.address,
                        "cuisine_type": newRestaurant.cuisineType,
                        "offers_english_menu": newRestaurant.offersEnglishMenu,
                        "walk_ins_ok": newRestaurant.walkInsOk,
                        "accepts_credit_cards": newRestaurant.acceptsCreditCards,
                        "notes": newRestaurant.notes,
                        "photo_urls": newRestaurant.photoUrls.map { url in ["url": url] }
                    ]
                ]
            )
    }

    //MARK: - PATCH Functions

    func update(id: Int, params: [String: AnyObject]) -> Future<HttpJson, RepoError> {
        return http
            .patch(
                "\(path)/\(id)",
                headers: buildHeaders(),
                parameters: ["restaurant": params]
            )
    }

    // MARK: - Private Methods
    private func buildHeaders() -> [String: String] {
        return [
            "Authorization": "Bearer \(sessionRepo.getToken()!)"
        ]
    }
}
