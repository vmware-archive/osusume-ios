import UIKit

class NavigationRouter : Router {
    let navigationController : UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func showNewRestaurantScreen() {
        let newRestaurantController = NewRestaurantViewController()

        navigationController.setViewControllers([newRestaurantController], animated: true)
    }

    func showRestaurantListScreen() {
        let restaurantListViewController = RestaurantListViewController(router: self)

        navigationController.setViewControllers([restaurantListViewController], animated: true)
    }
}