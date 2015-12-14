import UIKit

struct NavigationRouter : Router {
    let navigationController : UINavigationController

    func showNewRestaurantScreen() {
        let newRestaurantController = NewRestaurantViewController()

        navigationController.setViewControllers([newRestaurantController], animated: true)
    }
}