import UIKit

class NavigationRouter : Router {
    let navigationController : UINavigationController
    let http: Http

    init(navigationController: UINavigationController, http: Http) {
        self.navigationController = navigationController
        self.http = http
    }

    func showNewRestaurantScreen() {
        let newRestaurantController = NewRestaurantViewController(router: self, repo: HttpRestaurantRepo(http: http))
        navigationController.pushViewController(newRestaurantController, animated: true)
    }

    func showRestaurantListScreen() {
        let restaurantListViewController = RestaurantListViewController(router: self, repo: HttpRestaurantRepo(http: http))
        navigationController.setViewControllers([restaurantListViewController], animated: true)
    }

    func showRestaurantDetailScreen(id: Int) {
        let restaurantDetailViewController = RestaurantDetailViewController(router: self, repo: HttpRestaurantRepo(http: http), id: id)
        navigationController.pushViewController(restaurantDetailViewController, animated: true)
    }

    func showEditRestaurantScreen(restaurant: Restaurant) {
        let editRestaurantViewController = EditRestaurantViewController(router: self, repo: HttpRestaurantRepo(http: http), restaurant: restaurant)
        navigationController.pushViewController(editRestaurantViewController, animated: true)
    }
}