import Foundation
import Nimble
import XCTest

@testable import Osusume

class NavigationRouterTest: XCTestCase {

    var navigationRouter: NavigationRouter!
    var rootNavController: UINavigationController!
    var fakeSessionRepo: FakeSessionRepo!
    var fakeCuisineRepo: FakeCuisineRepo!

    override func setUp() {
        rootNavController = UINavigationController()
        fakeSessionRepo = FakeSessionRepo()
        fakeCuisineRepo = FakeCuisineRepo()

        navigationRouter = NavigationRouter(
            navigationController: rootNavController,
            sessionRepo: fakeSessionRepo,
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            userRepo: FakeUserRepo(),
            commentRepo: FakeCommentRepo(),
            cuisineRepo: fakeCuisineRepo,
            likeRepo: FakeLikeRepo(),
            priceRangeRepo: FakePriceRangeRepo()
        )
    }

    func test_showingNewRestaurantScreen() {
        navigationRouter.showNewRestaurantScreen()

        expect(self.rootNavController.topViewController).to(beAKindOf(NewRestaurantViewController))
    }

    func test_showingRestaurantListScreen() {
        navigationRouter.showRestaurantListScreen()

        expect(self.rootNavController.topViewController).to(beAKindOf(RestaurantListViewController))
    }

    func test_showingRestaurantDetailScreen() {
        navigationRouter.showRestaurantDetailScreen(1)

        expect(self.rootNavController.topViewController).to(beAKindOf(RestaurantDetailViewController))
    }

    func test_showingEditRestaurantScreen() {
        let restaurant = RestaurantFixtures.newRestaurant()
        navigationRouter.showEditRestaurantScreen(restaurant)

        expect(self.rootNavController.topViewController).to(beAKindOf(EditRestaurantViewController))
    }

    func test_showingLoginScreen() {
        navigationRouter.showLoginScreen()

        expect(self.rootNavController.topViewController).to(beAKindOf(LoginViewController))
    }

    func test_passesSessionRepo_toTheLoginScreen() {
        navigationRouter.showLoginScreen()

        let loginVC = rootNavController.topViewController as! LoginViewController
        let loginSessionRepo = loginVC.sessionRepo as! FakeSessionRepo

        expect(self.fakeSessionRepo === loginSessionRepo).to(beTrue())
    }

    func test_showingNewCommentScreen() {
        navigationRouter.showNewCommentScreen(1)

        expect(self.rootNavController.topViewController).to(beAKindOf(NewCommentViewController))
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

        expect(self.rootNavController.topViewController).toNot(beAKindOf(NewCommentViewController))
        expect(self.rootNavController.viewControllers.count).to(equal(1))
    }

    func test_showingImageScreen() {
        let url = NSURL(string: "my-awesome-url")!
        navigationRouter.showImageScreen(url)

        expect(self.rootNavController.topViewController).to(beAKindOf(ImageViewController))
        expect((self.rootNavController.topViewController as! ImageViewController).url)
            .to(equal(url))
    }

    func test_showingCuisineListScreen() {
        var window: UIWindow?
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = rootNavController
        window!.makeKeyAndVisible()

        let newRestaurantVC = NewRestaurantViewController(
            router: FakeRouter(),
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo()
        )
        rootNavController.pushViewController(newRestaurantVC, animated: false)


        navigationRouter.showFindCuisineScreen()


        let cuisineNavController = rootNavController.presentedViewController as? UINavigationController
        expect(cuisineNavController).to(beAKindOf(UINavigationController))
        expect(cuisineNavController?.topViewController).to(beAKindOf(CuisineListViewController))
    }

    func test_dismissPresentedNavigationController_dismissesPresentedNavigationController() {
        var window: UIWindow?
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = rootNavController
        window!.makeKeyAndVisible()
        rootNavController.pushViewController(UIViewController(), animated: false)

        let modalNavController = UINavigationController(rootViewController: UIViewController())
        rootNavController.presentViewController(
            modalNavController,
            animated: false,
            completion: nil
        )

        let presentedNavController = rootNavController.presentedViewController as? UINavigationController
        expect(presentedNavController?.topViewController).toNot(beNil())


        navigationRouter.dismissPresentedNavigationController()


        NSRunLoop.osu_advance(by: 1)
        expect(self.rootNavController.presentedViewController).to(beNil())
    }

    func test_dismissPresentedNavigationController_doesNotDismissPresentedViewController() {
        var window: UIWindow?
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = rootNavController
        window!.makeKeyAndVisible()
        rootNavController.pushViewController(UIViewController(), animated: false)

        rootNavController.presentViewController(
            UIViewController(),
            animated: false,
            completion: nil
        )

        let presentedViewController = rootNavController.presentedViewController
        expect(presentedViewController).toNot(beNil())


        navigationRouter.dismissPresentedNavigationController()


        NSRunLoop.osu_advance(by: 1)
        expect(self.rootNavController.presentedViewController).to(equal(presentedViewController))
    }

    func test_showingPriceRangeListScreen() {
        var window: UIWindow?
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = rootNavController
        window!.makeKeyAndVisible()

        let newRestaurantVC = NewRestaurantViewController(
            router: FakeRouter(),
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo()
        )
        rootNavController.pushViewController(newRestaurantVC, animated: false)


        navigationRouter.showPriceRangeListScreen()


        let priceRangeNavController = rootNavController.presentedViewController as? UINavigationController
        expect(priceRangeNavController).to(beAKindOf(UINavigationController))
        expect(priceRangeNavController?.topViewController).to(beAKindOf(PriceRangeListViewController))
    }
}
