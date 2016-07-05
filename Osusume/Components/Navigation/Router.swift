protocol Router {
    func showNewRestaurantScreen()
    func showRestaurantListScreen()
    func showRestaurantDetailScreen(id: Int)
    func showEditRestaurantScreen(restaurant: Restaurant)
    func showLoginScreen()
    func showNewCommentScreen(id: Int)
    func showImageScreen(url: NSURL)
    func showProfileScreen()
    func showMapScreen(latitude: Double, longitude: Double)

    func showFindCuisineScreen(delegate: CuisineSelectionDelegate)
    func showFindRestaurantScreen(delegate: SearchResultRestaurantSelectionDelegate)
    func showPriceRangeListScreen(delegate: PriceRangeSelectionDelegate)

    func dismissPresentedNavigationController()
    func popViewControllerOffStack()
}
