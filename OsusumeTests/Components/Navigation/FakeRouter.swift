@testable import Osusume

class FakeRouter : Router {
    var newRestaurantScreenIsShowing = false
    func showNewRestaurantScreen(animated: Bool) {
        newRestaurantScreenIsShowing = true
    }

    var restaurantListScreenIsShowing = false
    func showRestaurantListScreen(animated: Bool) {
        restaurantListScreenIsShowing = true
    }

    var restaurantDetailScreenIsShowing = false
    func showRestaurantDetailScreen(id: Int, animated: Bool) {
        restaurantDetailScreenIsShowing = true
    }

    var editRestaurantScreenIsShowing = false
    func showEditRestaurantScreen(restaurant: Restaurant, animated: Bool) {
        editRestaurantScreenIsShowing = true
    }

    var loginScreenIsShowing = false
    func showLoginScreen(animated: Bool) {
        loginScreenIsShowing = true
    }

    var newCommentScreenIsShowing = false
    var showNewCommentScreen_args = 0
    func showNewCommentScreen(id: Int, animated: Bool) {
        newCommentScreenIsShowing = true
        showNewCommentScreen_args = id
    }

    var dismissNewCommentScreen_wasCalled = false
    func dismissNewCommentScreen(animated: Bool) {
        dismissNewCommentScreen_wasCalled = true
    }

    var imageScreenIsShowing = false
    var showImageScreen_args = NSURL()
    func showImageScreen(url: NSURL, animated: Bool) {
        imageScreenIsShowing = true
        showImageScreen_args = url
    }

    var profileScreenIsShowing = false
    func showProfileScreen(animated: Bool) {
        profileScreenIsShowing = true
    }

    var showFindCuisineScreen_wasCalled = false
    func showFindCuisineScreen(animated: Bool) {
        showFindCuisineScreen_wasCalled = true
    }

    var dismissPresentedNavigationController_wasCalled = false
    func dismissPresentedNavigationController(animated: Bool) {
        dismissPresentedNavigationController_wasCalled = true
    }

    var popViewControllerOffStack_wasCalled = false
    func popViewControllerOffStack(animated: Bool) {
        popViewControllerOffStack_wasCalled = true
    }

    var showPriceRangeListScreen_wasCalled = false
    func showPriceRangeListScreen(animated: Bool) {
        showPriceRangeListScreen_wasCalled = true
    }

    var showFindRestaurantScreen_wasCalled = false
    func showFindRestaurantScreen(animated: Bool) {
        showFindRestaurantScreen_wasCalled = true
    }
}
