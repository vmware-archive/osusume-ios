struct NavigationRouter: Router {
    let navigationController : UINavigationController
    let sessionRepo: SessionRepo
    let restaurantRepo: RestaurantRepo
    let photoRepo: PhotoRepo
    let userRepo: UserRepo
    let commentRepo: CommentRepo
    let cuisineRepo: CuisineRepo
    let likeRepo: LikeRepo
    let priceRangeRepo: PriceRangeRepo
    let restaurantSearchRepo: RestaurantSearchRepo

    init(
        navigationController: UINavigationController,
        sessionRepo: SessionRepo,
        restaurantRepo: RestaurantRepo,
        photoRepo: PhotoRepo,
        userRepo: UserRepo,
        commentRepo: CommentRepo,
        cuisineRepo: CuisineRepo,
        likeRepo: LikeRepo,
        priceRangeRepo: PriceRangeRepo,
        restaurantSearchRepo: RestaurantSearchRepo)
    {
        self.navigationController = navigationController
        self.sessionRepo = sessionRepo
        self.restaurantRepo = restaurantRepo
        self.photoRepo = photoRepo
        self.userRepo = userRepo
        self.commentRepo = commentRepo
        self.cuisineRepo = cuisineRepo
        self.likeRepo = likeRepo
        self.priceRangeRepo = priceRangeRepo
        self.restaurantSearchRepo = restaurantSearchRepo
    }

    func showNewRestaurantScreen(animated: Bool) {
        let newRestaurantController = NewRestaurantViewController(
            router: self,
            restaurantRepo: restaurantRepo,
            photoRepo: photoRepo
        )
        presentViewControllerModallyWithinNavController(
            newRestaurantController,
            animated: animated
        )
    }

    func showRestaurantListScreen(animated: Bool) {
        let restaurantListViewController = RestaurantListViewController(
            router: self,
            repo: restaurantRepo,
            reloader: DefaultReloader(),
            photoRepo: photoRepo
        )

        navigationController.setViewControllers(
            [restaurantListViewController],
            animated: animated
        )
    }

    func showRestaurantDetailScreen(id: Int, animated: Bool) {
        let restaurantDetailViewController = RestaurantDetailViewController(
            router: self,
            reloader: DefaultReloader(),
            restaurantRepo: restaurantRepo,
            likeRepo: likeRepo,
            sessionRepo: sessionRepo,
            commentRepo: commentRepo,
            restaurantId: id
        )

        navigationController.pushViewController(
            restaurantDetailViewController,
            animated: animated
        )
    }

    func showEditRestaurantScreen(restaurant: Restaurant, animated: Bool) {
        let editRestaurantViewController = EditRestaurantViewController(
            router: self,
            repo: restaurantRepo,
            photoRepo: photoRepo,
            restaurant: restaurant
        )

        navigationController.pushViewController(
            editRestaurantViewController,
            animated: animated
        )
    }

    func showLoginScreen(animated: Bool) {
        let loginViewController = LoginViewController(
            router: self,
            repo: userRepo,
            sessionRepo: sessionRepo
        )

        navigationController.setViewControllers(
            [loginViewController],
            animated: animated
        )
    }

    func showNewCommentScreen(restaurantId: Int, animated: Bool) {
        let newCommentViewController = NewCommentViewController(
            router: self,
            commentRepo: commentRepo,
            restaurantId: restaurantId
        )

        navigationController.pushViewController(
            newCommentViewController,
            animated: animated
        )
    }

    func dismissNewCommentScreen(animated: Bool) {
        navigationController.popViewControllerAnimated(animated)
    }

    func showImageScreen(url: NSURL, animated: Bool) {
        let imageViewController = ImageViewController(url: url)

        navigationController.pushViewController(
            imageViewController,
            animated: animated
        )
    }

    func showProfileScreen(animated: Bool) {
        let profileViewController = ProfileViewController(
            router: self,
            userRepo: userRepo,
            sessionRepo: sessionRepo,
            photoRepo: photoRepo,
            reloader: DefaultReloader()
        )

        navigationController.pushViewController(
            profileViewController,
            animated: animated
        )
    }

    func showFindCuisineScreen(animated: Bool) {
        let newRestaurantNavVC = navigationController.presentedViewController as? UINavigationController
        let newRestaurantVC = newRestaurantNavVC!.topViewController as? NewRestaurantViewController
        let findCuisineTableViewController = CuisineListViewController(
            router: self,
            cuisineRepo: cuisineRepo,
            textSearch: DefaultTextSearch(),
            reloader: DefaultReloader(),
            delegate: newRestaurantVC!.formView
        )

        newRestaurantNavVC!.pushViewController(
            findCuisineTableViewController,
            animated: animated
        )
    }

    func showFindRestaurantScreen(animated: Bool) {
        let newRestaurantNavVC = navigationController.presentedViewController as? UINavigationController
        let newRestaurantVC = newRestaurantNavVC!.topViewController as? NewRestaurantViewController
        let findRestaurantViewController = FindRestaurantViewController(
            router: self,
            restaurantSearchRepo: restaurantSearchRepo,
            reloader: DefaultReloader(),
            searchResultRestaurantSelectionDelegate: newRestaurantVC!.formView
        )

        newRestaurantNavVC!.pushViewController(
            findRestaurantViewController,
            animated: animated
        )
    }

    func dismissPresentedNavigationController(animated: Bool) {
        if let presentedVC = navigationController.presentedViewController as? UINavigationController {
            presentedVC.dismissViewControllerAnimated(animated, completion: nil)
        }
    }

    func popViewControllerOffStack(animated: Bool) {
        if let presentedNavVC = navigationController.presentedViewController as? UINavigationController {
            presentedNavVC.popViewControllerAnimated(animated)
        } else {
            navigationController.popViewControllerAnimated(animated)
        }
    }

    func showPriceRangeListScreen(animated: Bool) {
        let newRestaurantNavVC = navigationController.presentedViewController as? UINavigationController
        let newRestaurantVC = newRestaurantNavVC!.topViewController as? NewRestaurantViewController
        let priceRangeListViewController = PriceRangeListViewController(
            priceRangeRepo: priceRangeRepo,
            reloader: DefaultReloader(),
            router: self,
            priceRangeSelection: newRestaurantVC!.formView
        )

        newRestaurantNavVC!.pushViewController(
            priceRangeListViewController,
            animated: animated
        )
    }

    // MARK: - Private Methods
    func presentViewControllerModallyWithinNavController(
        viewController: UIViewController, animated: Bool)
    {
        let containerNavigationController = UINavigationController()
        containerNavigationController.setViewControllers(
            [viewController],
            animated: animated
        )

        navigationController.presentViewController(
            containerNavigationController,
            animated: animated,
            completion: nil
        )
    }
}
