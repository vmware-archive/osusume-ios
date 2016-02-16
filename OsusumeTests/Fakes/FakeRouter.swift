@testable import Osusume

class FakeRouter : Router {
    var newRestaurantScreenIsShowing = false
    func showNewRestaurantScreen() {
        newRestaurantScreenIsShowing = true
    }

    var restaurantListScreenIsShowing = false
    func showRestaurantListScreen() {
        restaurantListScreenIsShowing = true
    }

    var restaurantDetailScreenIsShowing = false
    func showRestaurantDetailScreen(id: Int) {
        restaurantDetailScreenIsShowing = true
    }

    var editRestaurantScreenIsShowing = false
    func showEditRestaurantScreen(restaurant: Restaurant) {
        editRestaurantScreenIsShowing = true
    }

    var loginScreenIsShowing = false
    func showLoginScreen() {
        loginScreenIsShowing = true
    }

    var newCommentScreenIsShowing = false
    var showNewCommentScreen_args = 0
    func showNewCommentScreen(id: Int) {
        newCommentScreenIsShowing = true
        showNewCommentScreen_args = id
    }
}
