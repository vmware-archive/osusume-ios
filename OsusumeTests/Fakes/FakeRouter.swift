@testable import Osusume

class FakeRouter : Router {
    var newRestaurantScreenIsShowing = false
    func showNewRestaurantScreen() {
        setAllToFalse()
        newRestaurantScreenIsShowing = true
    }

    var restaurantListScreenIsShowing = false
    func showRestaurantListScreen() {
        setAllToFalse()
        restaurantListScreenIsShowing = true
    }

    var restaurantDetailScreenIsShowing = false
    func showRestaurantDetailScreen(id: Int) {
        setAllToFalse()
        restaurantDetailScreenIsShowing = true
    }

    var editRestaurantScreenIsShowing = false
    func showEditRestaurantScreen(restaurant: Restaurant) {
        setAllToFalse()
        editRestaurantScreenIsShowing = true
    }

    var loginScreenIsShowing = false
    func showLoginScreen() {
        setAllToFalse()
        loginScreenIsShowing = true
    }

    var newCommentScreenIsShowing = false
    var showNewCommentScreen_args = 0
    func showNewCommentScreen(id: Int) {
        newCommentScreenIsShowing = true
        showNewCommentScreen_args = id
    }


    func setAllToFalse() {
        newRestaurantScreenIsShowing = false
        restaurantListScreenIsShowing = false
        restaurantDetailScreenIsShowing = false
        editRestaurantScreenIsShowing = false
        loginScreenIsShowing = false
    }
}
