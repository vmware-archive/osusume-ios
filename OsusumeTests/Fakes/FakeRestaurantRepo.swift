import BrightFutures
@testable import Osusume

class FakeRestaurantRepo : RestaurantRepo {
    var createdRestaurant : Restaurant? = nil

    var restaurantsPromise = Promise<[Restaurant], RepoError>()
    func getAll() -> Future<[Restaurant], RepoError> {
        restaurantsPromise.success([
            Restaurant(id: 1, name: "つけめんTETSU", address: "", cuisineType: "つけめん", offersEnglishMenu: true, walkInsOk: true, acceptsCreditCards: true, notes: "This place is great", author: "Simon"),
            Restaurant(id: 2, name: "とんかつ 豚組食堂"),
            Restaurant(id: 3, name: "Coco Curry"),
            ])
        return restaurantsPromise.future
    }

    func create(params: [String : AnyObject]) -> Future<HttpJson, RepoError> {
        let promise = Promise<HttpJson, RepoError>()
        promise.success(HttpJson())

        createdRestaurant = Restaurant(id: 0,
            name: params["name"] as! String,
            address: params["address"] as! String,
            cuisineType: params["cuisine_type"] as! String,
            offersEnglishMenu: params["offers_english_menu"] as! Bool,
            walkInsOk: params["walk_ins_ok"] as! Bool,
            acceptsCreditCards: params["accepts_credit_cards"] as! Bool,
            notes: params["notes"] as! String,
            author: "Fake user")

        return promise.future
    }

    var restaurantPromise = Promise<Restaurant, RepoError>()
    func getOne(id: Int) -> Future<Restaurant, RepoError> {
        restaurantPromise.success(createdRestaurant!)
        return restaurantPromise.future
    }

    func update(id: Int, params: [String: AnyObject]) -> Future<HttpJson, RepoError> {
        let promise = Promise<HttpJson, RepoError>()
        promise.success(HttpJson())

        createdRestaurant = Restaurant(id: 0,
            name: params["name"] as! String,
            address: params["address"] as! String,
            cuisineType: params["cuisine_type"] as! String,
            offersEnglishMenu: params["offers_english_menu"] as! Bool,
            walkInsOk: params["walk_ins_ok"] as! Bool,
            acceptsCreditCards: params["accepts_credit_cards"] as! Bool,
            notes: params["notes"] as! String,
            author: "Fake user")
        
        return promise.future
    }
}