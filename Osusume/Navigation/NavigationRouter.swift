import UIKit

class NavigationRouter : Router {
    let navigationController : UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func showNewRestaurantScreen() {
        let newRestaurantController = NewRestaurantViewController(router: self, repo: HttpRestaurantRepo())
        navigationController.pushViewController(newRestaurantController, animated: true)
    }

    func showRestaurantListScreen() {
        let restaurantListViewController = RestaurantListViewController(router: self, repo: HttpRestaurantRepo())
        navigationController.setViewControllers([restaurantListViewController], animated: true)
    }

    func showRestaurantDetailScreen(id: Int) {
        let restaurantDetailViewController = RestaurantDetailViewController(router: self, repo: HttpRestaurantRepo(), id: id)
        navigationController.pushViewController(restaurantDetailViewController, animated: true)
    }

    func showEditRestaurantScreen(restaurant: Restaurant) {
        let editRestaurantViewController = EditRestaurantViewController(router: self, repo: HttpRestaurantRepo(), restaurant: restaurant)
        navigationController.pushViewController(editRestaurantViewController, animated: true)
    }

    func didAddRestaurant(controller: NewRestaurantViewController) {
        self.showRestaurantListScreen()
    }
}