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

    var dismissNewCommentScreen_wasCalled = false
    func dismissNewCommentScreen(animated: Bool) {
        dismissNewCommentScreen_wasCalled = true
    }

    var imageScreenIsShowing = false
    var showImageScreen_args = NSURL()
    func showImageScreen(url: NSURL) {
        imageScreenIsShowing = true
        showImageScreen_args = url
    }

    var profileScreenIsShowing = false
    func showProfileScreen() {
        profileScreenIsShowing = true
    }

    var showFindCuisineScreen_wasCalled = false
    func showFindCuisineScreen() {
        showFindCuisineScreen_wasCalled = true
    }

    var dismissFindCuisineScreen_wasCalled = false
    func dismissFindCuisineScreen() {
        dismissFindCuisineScreen_wasCalled = true
    }

    var showPriceRangeListScreen_wasCalled = false
    func showPriceRangeListScreen() {
        showPriceRangeListScreen_wasCalled = true
    }
}
