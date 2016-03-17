import UIKit

class NavigationRouter: Router {
    let navigationController : UINavigationController
    let sessionRepo: SessionRepo
    let restaurantRepo: RestaurantRepo
    let photoRepo: PhotoRepo
    let userRepo: UserRepo
    let commentRepo: CommentRepo
    let postRepo: PostRepo

    init(
        navigationController: UINavigationController,
        sessionRepo: SessionRepo,
        restaurantRepo: RestaurantRepo,
        photoRepo: PhotoRepo,
        userRepo: UserRepo,
        commentRepo: CommentRepo,
        postRepo: PostRepo)
    {
        self.navigationController = navigationController
        self.sessionRepo = sessionRepo
        self.restaurantRepo = restaurantRepo
        self.photoRepo = photoRepo
        self.userRepo = userRepo
        self.commentRepo = commentRepo
        self.postRepo = postRepo
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
            likeRepo: NetworkLikeRepo(),
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
            postRepo: postRepo,
            photoRepo: photoRepo,
            reloader: DefaultReloader()
        )

        navigationController.pushViewController(
            profileViewController,
            animated: true
        )
    }

    func showFindCuisineScreen() {
        let cuisineNavController = UINavigationController()
        let findCuisineTableViewController = CuisineListTableViewController(
            router: self
        )

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

    func dismissFindCuisineScreen() {
        let presentedVC = navigationController.presentedViewController as? UINavigationController
        presentedVC!.dismissViewControllerAnimated(true, completion: nil)
    }
}
