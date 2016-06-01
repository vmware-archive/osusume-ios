protocol Router {
    func showNewRestaurantScreen()
    func showRestaurantListScreen()
    func showRestaurantDetailScreen(id: Int)
    func showEditRestaurantScreen(restaurant: Restaurant)
    func showLoginScreen()
    func showNewCommentScreen(id: Int)
    func dismissNewCommentScreen(animated: Bool)
    func showImageScreen(url: NSURL)
    func showProfileScreen()

    func showFindCuisineScreen(animated: Bool)
    func showFindRestaurantScreen(animated: Bool)
    func showPriceRangeListScreen(animated: Bool)

    func dismissPresentedNavigationController()
    func popViewControllerOffStack(animated: Bool)
}
