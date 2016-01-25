import Foundation
import Quick
import Nimble
import BrightFutures
import Result
@testable import Osusume

class FakeRouter : Router {
    var newRestaurantScreenIsShowing = false
    var restaurantListScreenIsShowing = false
    var restaurantDetailScreenIsShowing = false
    var editRestaurantScreenIsShowing = false
    var loginScreenIsShowing = false

    func showNewRestaurantScreen() {
        setAllToFalse()
        newRestaurantScreenIsShowing = true
    }

    func showRestaurantListScreen() {
        setAllToFalse()
        restaurantListScreenIsShowing = true
    }

    func showRestaurantDetailScreen(id: Int) {
        setAllToFalse()
        restaurantDetailScreenIsShowing = true
    }

    func showEditRestaurantScreen(restaurant: Restaurant) {
        setAllToFalse()
        editRestaurantScreenIsShowing = true
    }

    func showLoginScreen() {
        setAllToFalse()
        loginScreenIsShowing = true
    }

    func setAllToFalse() {
        newRestaurantScreenIsShowing = false
        restaurantListScreenIsShowing = false
        restaurantDetailScreenIsShowing = false
        editRestaurantScreenIsShowing = false
        loginScreenIsShowing = false
    }
}

class FakeRestaurantRepo : RestaurantRepo {
    var createdRestaurant : Restaurant? = nil

    var restaurantsPromise = Promise<[Restaurant], RepoError>()
    func getAll() -> Future<[Restaurant], RepoError> {
        restaurantsPromise.success([
            Restaurant(id: 1, name: "つけめんTETSU", address: "", cuisineType: "つけめん", offersEnglishMenu: true, walkInsOk: true, acceptsCreditCards: true),
            Restaurant(id: 2, name: "とんかつ 豚組食堂"),
            Restaurant(id: 3, name: "Coco Curry"),
            ])
        return restaurantsPromise.future
    }

    func create(params: [String : AnyObject]) -> Future<HttpJson, RepoError> {
        let promise = Promise<HttpJson, RepoError>()
        promise.success(HttpJson())

        createdRestaurant = Restaurant(id: 0,
            name: params["name"]! as! String,
            address: params["address"]! as! String,
            cuisineType: params["cuisine_type"]! as! String,
            offersEnglishMenu: params["offers_english_menu"] as! Bool,
            walkInsOk: params["walk_ins_ok"] as! Bool,
            acceptsCreditCards: params["accepts_credit_cards"] as! Bool)

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
            name: params["name"]! as! String,
            address: params["address"]! as! String,
            cuisineType: params["cuisine_type"]! as! String,
            offersEnglishMenu: params["offers_english_menu"] as! Bool,
            walkInsOk: params["walk_ins_ok"] as! Bool,
            acceptsCreditCards: params["accepts_credit_cards"] as! Bool)

        return promise.future
    }
}

class FakeUserRepo : UserRepo {
    var submittedEmail : String? = nil
    var submittedPassword : String? = nil

    var stringPromise = Promise<String, RepoError>()

    func login(email : String, password: String) -> Future<String, RepoError> {
        stringPromise.success("token-value")

        self.submittedEmail = email
        self.submittedPassword = password

        return stringPromise.future
    }
}