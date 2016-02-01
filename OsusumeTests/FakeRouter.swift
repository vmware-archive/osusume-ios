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
