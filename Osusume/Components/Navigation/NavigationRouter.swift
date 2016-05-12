class NavigationRouter: Router {
    let navigationController : UINavigationController
    let sessionRepo: SessionRepo
    let restaurantRepo: RestaurantRepo
    let photoRepo: PhotoRepo
    let userRepo: UserRepo
    let commentRepo: CommentRepo
    let cuisineRepo: CuisineRepo
    let likeRepo: LikeRepo
    let priceRangeRepo: PriceRangeRepo

    init(
        navigationController: UINavigationController,
        sessionRepo: SessionRepo,
        restaurantRepo: RestaurantRepo,
        photoRepo: PhotoRepo,
        userRepo: UserRepo,
        commentRepo: CommentRepo,
        cuisineRepo: CuisineRepo,
        likeRepo: LikeRepo,
        priceRangeRepo: PriceRangeRepo)
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
    }

    func showNewRestaurantScreen() {
        let newRestaurantController = NewRestaurantViewController(
            router: self,
            restaurantRepo: restaurantRepo,
            photoRepo: photoRepo
        )

        navigationController.pushViewController(
            newRestaurantController,
            animated: true
        )
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
            animated: true
        )
    }

    func showRestaurantDetailScreen(id: Int) {
        let restaurantDetailViewController = RestaurantDetailViewController(
            router: self,
            reloader: DefaultReloader(),
            restaurantRepo: restaurantRepo,
            likeRepo: likeRepo,
            restaurantId: id
        )

        navigationController.pushViewController(
            restaurantDetailViewController,
            animated: true
        )
    }

    func showEditRestaurantScreen(restaurant: Restaurant) {
        let editRestaurantViewController = EditRestaurantViewController(
            router: self,
            repo: restaurantRepo,
            restaurant: restaurant
        )

        navigationController.pushViewController(
            editRestaurantViewController,
            animated: true
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
            animated: true
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
            animated: true
        )
    }

    func dismissNewCommentScreen(animated: Bool) {
        navigationController.popViewControllerAnimated(animated)
    }

    func showImageScreen(url: NSURL) {
        let imageViewController = ImageViewController(url: url)

        navigationController.pushViewController(
            imageViewController,
            animated: true
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
            animated: true
        )
    }

    func showFindCuisineScreen() {
        let newRestaurantVC = navigationController.topViewController as? NewRestaurantViewController
        let findCuisineTableViewController = CuisineListViewController(
            router: self,
            cuisineRepo: cuisineRepo,
            textSearch: DefaultTextSearch(),
            reloader: DefaultReloader(),
            delegate: newRestaurantVC!.formView
        )

        let cuisineNavController = UINavigationController()
        cuisineNavController.setViewControllers(
            [findCuisineTableViewController],
            animated: true
        )

        navigationController.presentViewController(
            cuisineNavController,
            animated: true,
            completion: nil
        )
    }

    func dismissPresentedNavigationController() {
        if let presentedVC = navigationController.presentedViewController as? UINavigationController {
            presentedVC.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func showPriceRangeListScreen() {
        let newRestaurantVC = navigationController.topViewController as? NewRestaurantViewController

        let priceRangeListViewController = PriceRangeListViewController(
            priceRangeRepo: priceRangeRepo,
            reloader: DefaultReloader(),
            router: self,
            priceRangeSelection: newRestaurantVC!.formView
        )

        let priceRangeNavController = UINavigationController()
        priceRangeNavController.setViewControllers(
            [priceRangeListViewController],
            animated: false
        )

        navigationController.presentViewController(
            priceRangeNavController,
            animated: true,
            completion: nil
        )
    }
}
