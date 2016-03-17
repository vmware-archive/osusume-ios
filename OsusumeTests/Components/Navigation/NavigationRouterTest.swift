import Foundation
import Nimble
import XCTest

@testable import Osusume

class NavigationRouterTest: XCTestCase {

    var navigationRouter: NavigationRouter!
    var navController: UINavigationController!
    var fakeSessionRepo: FakeSessionRepo!

    override func setUp() {
        navController = UINavigationController()
        fakeSessionRepo = FakeSessionRepo()

        navigationRouter = NavigationRouter(
            navigationController: navController,
            sessionRepo: fakeSessionRepo,
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            userRepo: FakeUserRepo(),
            commentRepo: FakeCommentRepo(),
            postRepo: FakePostRepo()
        )
    }

    func test_showingNewRestaurantScreen() {
        navigationRouter.showNewRestaurantScreen()

        expect(self.navController.topViewController).to(beAKindOf(NewRestaurantViewController))
    }

    func test_showingRestaurantListScreen() {
        navigationRouter.showRestaurantListScreen()

        expect(self.navController.topViewController).to(beAKindOf(RestaurantListViewController))
    }

    func test_showingRestaurantDetailScreen() {
        navigationRouter.showRestaurantDetailScreen(1)

        expect(self.navController.topViewController).to(beAKindOf(RestaurantDetailViewController))
    }

    func test_showingEditRestaurantScreen() {
        let restaurant = RestaurantFixtures.newRestaurant()
        navigationRouter.showEditRestaurantScreen(restaurant)

        expect(self.navController.topViewController).to(beAKindOf(EditRestaurantViewController))
    }

    func test_showingLoginScreen() {
        navigationRouter.showLoginScreen()

        expect(self.navController.topViewController).to(beAKindOf(LoginViewController))
    }

    func test_passesSessionRepo_toTheLoginScreen() {
        navigationRouter.showLoginScreen()

        let loginVC = navController.topViewController as! LoginViewController
        let loginSessionRepo = loginVC.sessionRepo as? FakeSessionRepo

        expect(self.fakeSessionRepo === loginSessionRepo).to(beTrue())
    }

    func test_showingNewCommentScreen() {
        navigationRouter.showNewCommentScreen(1)

        expect(self.navController.topViewController).to(beAKindOf(NewCommentViewController))
    }

    func test_dismissesNewCommentScreen() {
        let fakeRestaurantId = 0

        navigationRouter.navigationController.setViewControllers(
            [
                UIViewController(),
                NewCommentViewController(
                    router: FakeRouter(),
                    commentRepo: FakeCommentRepo(),
                    restaurantId: fakeRestaurantId
                )
            ],
            animated: false
        )
        navigationRouter.dismissNewCommentScreen(false)

        expect(self.navController.topViewController).toNot(beAKindOf(NewCommentViewController))
        expect(self.navController.viewControllers.count).to(equal(1))
    }

    func test_showingImageScreen() {
        let url = NSURL(string: "my-awesome-url")!
        navigationRouter.showImageScreen(url)

        expect(self.navController.topViewController).to(beAKindOf(ImageViewController))
        expect((self.navController.topViewController as! ImageViewController).url)
            .to(equal(url))
    }

    func test_showingCuisineListScreen() {
        var window: UIWindow?
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = navController
        window!.makeKeyAndVisible()

        let newRestaurantVC = NewRestaurantViewController(
            router: FakeRouter(),
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo()
        )
        navController.pushViewController(newRestaurantVC, animated: false)

        navigationRouter.showFindCuisineScreen()

        let cuisineNavController = navController.presentedViewController as? UINavigationController
        expect(cuisineNavController).to(beAKindOf(UINavigationController))
        expect(cuisineNavController?.topViewController).to(beAKindOf(CuisineListTableViewController))
    }
}
