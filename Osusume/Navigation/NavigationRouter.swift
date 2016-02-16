import UIKit

class NavigationRouter : Router {
    let navigationController : UINavigationController
    let http: Http
    let sessionRepo: SessionRepo
    let photoRepo: PhotoRepo

    init(
        navigationController: UINavigationController,
        http: Http,
        sessionRepo: SessionRepo,
        photoRepo: PhotoRepo)
    {
        self.navigationController = navigationController
        self.http = http
        self.sessionRepo = sessionRepo
        self.photoRepo = photoRepo
    }

    func showNewRestaurantScreen() {
        let newRestaurantController = NewRestaurantViewController(
            router: self,
            restaurantRepo: HttpRestaurantRepo(http: http),
            photoRepo: photoRepo
        )
        navigationController.pushViewController(newRestaurantController, animated: true)
    }

    func showRestaurantListScreen() {
        let restaurantListViewController = RestaurantListViewController(
            router: self,
            repo: HttpRestaurantRepo(http: http),
            sessionRepo: sessionRepo
        )
        navigationController.setViewControllers([restaurantListViewController], animated: true)
    }

    func showRestaurantDetailScreen(id: Int) {
        let restaurantDetailViewController = RestaurantDetailViewController(
            router: self,
            repo: HttpRestaurantRepo(http: http),
            restaurantId: id
        )
        navigationController.pushViewController(restaurantDetailViewController, animated: true)
    }

    func showEditRestaurantScreen(restaurant: Restaurant) {
        let editRestaurantViewController = EditRestaurantViewController(
            router: self,
            repo: HttpRestaurantRepo(http: http),
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