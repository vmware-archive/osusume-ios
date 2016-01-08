import Foundation
import Quick
import Nimble
import BrightFutures
import Result
@testable import Osusume


class FakeRouter : Router {
    var newRestaurantScreenIsShowing = false
    var restaurantListScreenIsShowing = false
    var RestaurantDetailScreenIsShowing = false

    func showNewRestaurantScreen() {
        newRestaurantScreenIsShowing = true
    }

    func showRestaurantListScreen() {
        restaurantListScreenIsShowing = true
    }

    func showRestaurantDetailScreen(id: Int) {
        RestaurantDetailScreenIsShowing = true
    }
}

class FakeRestaurantRepo : Repo {
    var createdRestaurant : Restaurant? = nil

    var restaurantsPromise = Promise<[Restaurant], RepoError>()
    func getAll() -> Future<[Restaurant], RepoError> {
        restaurantsPromise.success([
            Restaurant(id: 1, name: "つけめんTETSU"),
            Restaurant(id: 2, name: "とんかつ 豚組食堂"),
            Restaurant(id: 3, name: "Coco Curry"),
            ])
        return restaurantsPromise.future
    }

    var stringPromise = Promise<String, RepoError>()
    func create(params: [String : AnyObject]) -> Future<String, RepoError> {
        stringPromise.success("OK")
        createdRestaurant = Restaurant(id: 0,
            name: params["name"]! as! String,
            address: params["address"]! as! String,
            cuisineType: params["cuisine_type"]! as! String,
            offersEnglishMenu: params["offers_english_menu"] as! Bool,
            walkInsOk: params["walk_ins_ok"] as! Bool,
            acceptsCreditCards: params["accepts_credit_cards"] as! Bool)
        return stringPromise.future
    }

    var restaurantPromise = Promise<Restaurant, RepoError>()
    func getOne(id: Int) -> Future<Restaurant, RepoError> {
        restaurantPromise.success(createdRestaurant!)
        return restaurantPromise.future
    }
}