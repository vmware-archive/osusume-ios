import UIKit

class NavigationRouter : Router {
    let navigationController : UINavigationController
    let http: Http
    let sessionRepo: SessionRepo
    let restaurantRepo: RestaurantRepo
    let photoRepo: PhotoRepo

    init(
        navigationController: UINavigationController,
        http: Http,
        sessionRepo: SessionRepo,
        restaurantRepo: RestaurantRepo,
        photoRepo: PhotoRepo)
    {
        self.navigationController = navigationController
        self.http = http
        self.sessionRepo = sessionRepo
        self.restaurantRepo = restaurantRepo
        self.photoRepo = photoRepo
    }

    func showNewRestaurantScreen() {
        let newRestaurantController = NewRestaurantViewController(
            router: self,
            restaurantRepo: restaurantRepo,
            photoRepo: photoRepo
        )
        navigationController.pushViewController(newRestaurantController, animated: true)
    }

    func showRestaurantListScreen() {
        let restaurantListViewController = RestaurantListViewController(
            router: self,
            repo: restaurantRepo,
            sessionRepo: sessionRepo
        )
        navigationController.setViewControllers([restaurantListViewController], animated: true)
    }

    func showRestaurantDetailScreen(id: Int) {
        let restaurantDetailViewController = RestaurantDetailViewController(
            router: self,
            repo: restaurantRepo,
            restaurantId: id
        )
        navigationController.pushViewController(restaurantDetailViewController, animated: true)
    }

    func showEditRestaurantScreen(restaurant: Restaurant) {
        let editRestaurantViewController = EditRestaurantViewController(
            router: self,
            repo: restaurantRepo,
            restaurant: restaurant
        )
        navigationController.pushViewController(editRestaurantViewController, animated: true)
    }

    func showLoginScreen() {
        let loginViewController = LoginViewController(
            router: self,
            repo: HttpUserRepo(http: http),
            sessionRepo: sessionRepo
        )

        navigationController.setViewControllers([loginViewController], animated: true)
    }

    func showNewCommentScreen(restaurantId: Int) {
        let newCommentViewController = NewCommentViewController()

        navigationController.pushViewController(newCommentViewController, animated: true)
    }
}