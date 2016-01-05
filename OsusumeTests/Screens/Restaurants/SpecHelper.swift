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
    var restaurantsPromise = Promise<[Restaurant], RepoError>()
    func getAll() -> Future<[Restaurant], RepoError> {
        restaurantsPromise.success([
            Restaurant(name: "つけめんTETSU"),
            Restaurant(name: "とんかつ 豚組食堂"),
            Restaurant(name: "Coco Curry"),
            ])
        return restaurantsPromise.future
    }

    var stringPromise = Promise<String, RepoError>()
    func create(params: [String : String]) -> Future<String, RepoError> {
        stringPromise.success("OK")
        return stringPromise.future
    }

    var restaurantPromise = Promise<Restaurant, RepoError>()
    func getOne(id: Int) -> Future<Restaurant, RepoError> {
        restaurantPromise.success(Restaurant(name: "First Restaurant"))
        return restaurantPromise.future
    }
}