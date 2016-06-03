protocol Router {
    func showNewRestaurantScreen(animated: Bool)
    func showRestaurantListScreen(animated: Bool)
    func showRestaurantDetailScreen(id: Int, animated: Bool)
    func showEditRestaurantScreen(restaurant: Restaurant, animated: Bool)
    func showLoginScreen(animated: Bool)
    func showNewCommentScreen(id: Int, animated: Bool)
    func dismissNewCommentScreen(animated: Bool)
    func showImageScreen(url: NSURL, animated: Bool)
    func showProfileScreen(animated: Bool)

    func showFindCuisineScreen(animated: Bool)
    func showFindRestaurantScreen(animated: Bool)
    func showPriceRangeListScreen(animated: Bool)

    func dismissPresentedNavigationController(animated: Bool)
    func popViewControllerOffStack(animated: Bool)
}
