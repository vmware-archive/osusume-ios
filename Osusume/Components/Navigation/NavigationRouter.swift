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
    let animated: Bool

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
        restaurantSearchRepo: RestaurantSearchRepo,
        animated: Bool
    ) {
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
        self.animated = animated
    }

    func showNewRestaurantScreen() {
        let newRestaurantController = NewRestaurantViewController(
            router: self,
            restaurantRepo: restaurantRepo,
            photoRepo: photoRepo
        )
        presentViewControllerModallyWithinNavController(newRestaurantController)
    }

    func showRestaurantListScreen() {
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

    func showRestaurantDetailScreen(id: Int) {
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

    func showEditRestaurantScreen(restaurant: Restaurant) {
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

    func showLoginScreen() {
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

    func showNewCommentScreen(restaurantId: Int) {
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

    func dismissNewCommentScreen() {
        navigationController.popViewControllerAnimated(animated)
    }

    func showImageScreen(url: NSURL) {
        let imageViewController = ImageViewController(url: url)

        navigationController.pushViewController(
            imageViewController,
            animated: animated
        )
    }

    func showProfileScreen() {
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

    func showFindCuisineScreen() {
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

    func showFindRestaurantScreen() {
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

    func dismissPresentedNavigationController() {
        if let presentedVC = navigationController.presentedViewController as? UINavigationController {
            presentedVC.dismissViewControllerAnimated(animated, completion: nil)
        }
    }

    func popViewControllerOffStack() {
        if let presentedNavVC = navigationController.presentedViewController as? UINavigationController {
            presentedNavVC.popViewControllerAnimated(animated)
        } else {
            navigationController.popViewControllerAnimated(animated)
        }
    }

    func showPriceRangeListScreen() {
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
        viewController: UIViewController)
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
