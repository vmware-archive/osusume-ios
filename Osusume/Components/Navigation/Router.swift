protocol Router: class {
    func showNewRestaurantScreen()
    func showRestaurantListScreen()
    func showRestaurantDetailScreen(id: Int)
    func showEditRestaurantScreen(restaurant: Restaurant)
    func showLoginScreen()
    func showNewCommentScreen(id: Int)
    func dismissNewCommentScreen(animated: Bool)
    func showImageScreen(url: NSURL)
    func showProfileScreen()

    func showFindCuisineScreen()
    func showPriceRangeListScreen()

    func dismissPresentedNavigationController()
}
