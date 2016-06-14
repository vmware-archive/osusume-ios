import XCTest
import Nimble
@testable import Osusume

class NavigationRouterTest: XCTestCase {

    var navigationRouter: NavigationRouter!
    var rootNavController: UINavigationController!
    var fakeSessionRepo: FakeSessionRepo!

    override func setUp() {
        rootNavController = UINavigationController()
        fakeSessionRepo = FakeSessionRepo()

        navigationRouter = NavigationRouter(
            navigationController: rootNavController,
            sessionRepo: fakeSessionRepo,
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            userRepo: FakeUserRepo(),
            commentRepo: FakeCommentRepo(),
            cuisineRepo: FakeCuisineRepo(),
            likeRepo: FakeLikeRepo(),
            priceRangeRepo: FakePriceRangeRepo(),
            restaurantSearchRepo: FakeRestaurantSearchRepo(),
            animated: false
        )
    }

    func test_showingNewRestaurantScreen() {
        configureUIWindowWithRootViewController(rootNavController)

        let restaurantListVC = RestaurantListViewController(
            router: navigationRouter,
            repo: FakeRestaurantRepo(),
            reloader: FakeReloader(),
            photoRepo: FakePhotoRepo()
        )
        rootNavController.pushViewController(restaurantListVC, animated: false)


        navigationRouter.showNewRestaurantScreen()


        let newRestaurantNavController = rootNavController.presentedViewController as? UINavigationController
        expect(newRestaurantNavController).to(beAKindOf(UINavigationController))
        expect(newRestaurantNavController?.topViewController).to(beAKindOf(NewRestaurantViewController))
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
        configureUIWindowWithRootViewController(rootNavController)

        let restaurantDetailVC = UIViewController()
        rootNavController.pushViewController(restaurantDetailVC, animated: false)

        let restaurant = RestaurantFixtures.newRestaurant()
        navigationRouter.showEditRestaurantScreen(restaurant)

        let editRestaurantNavController = rootNavController.presentedViewController as? UINavigationController
        expect(editRestaurantNavController).to(beAKindOf(UINavigationController))
        expect(editRestaurantNavController?.topViewController).to(beAKindOf(EditRestaurantViewController))
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
        navigationRouter.dismissNewCommentScreen()

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
        configureUIWindowWithRootViewController(rootNavController)
        rootNavController.setViewControllers(
            [UIViewController()],
            animated: false
        )

        let newRestaurantVC = NewRestaurantViewController(
            router: navigationRouter,
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            reloader: FakeReloader()
        )
        let newRestaurantNavVC = UINavigationController(
            rootViewController: newRestaurantVC
        )

        rootNavController.presentViewController(
            newRestaurantNavVC,
            animated: false,
            completion: nil
        )


        navigationRouter.showFindCuisineScreen()


        expect(newRestaurantNavVC.topViewController).to(beAKindOf(CuisineListViewController))
    }

    func test_dismissPresentedNavigationController_dismissesPresentedNavigationController() {
        configureUIWindowWithRootViewController(rootNavController)
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
        configureUIWindowWithRootViewController(rootNavController)
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
        configureUIWindowWithRootViewController(rootNavController)
        rootNavController.setViewControllers(
            [UIViewController()],
            animated: false
        )

        let newRestaurantVC = NewRestaurantViewController(
            router: navigationRouter,
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            reloader: FakeReloader()
        )
        let newRestaurantNavVC = UINavigationController(
            rootViewController: newRestaurantVC
        )

        rootNavController.presentViewController(
            newRestaurantNavVC,
            animated: false,
            completion: nil
        )


        navigationRouter.showPriceRangeListScreen()


        expect(newRestaurantNavVC.topViewController).to(beAKindOf(PriceRangeListViewController))
    }

    func test_showingFindRestaurantScreen() {
        configureUIWindowWithRootViewController(rootNavController)
        rootNavController.setViewControllers(
            [UIViewController()],
            animated: false
        )
        let newRestaurantVC = NewRestaurantViewController(
            router: FakeRouter(),
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            reloader: FakeReloader()
        )
        let newRestaurantNavVC = UINavigationController(
            rootViewController: newRestaurantVC
        )

        rootNavController.presentViewController(
            newRestaurantNavVC,
            animated: false,
            completion: nil
        )


        navigationRouter.showFindRestaurantScreen()


        expect(newRestaurantNavVC.topViewController).to(beAKindOf(FindRestaurantViewController))
    }

    func test_popViewControllerOffStack_popsViewControllerOffOfRootVC() {
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        rootNavController.setViewControllers(
            [vc1, vc2],
            animated: false
        )


        navigationRouter.popViewControllerOffStack()


        expect(self.rootNavController.topViewController === vc1).to(beTrue())
    }

    func test_popViewControllerOffStack_popsViewControllerOffOfPresentedVC() {
        configureUIWindowWithRootViewController(rootNavController)
        rootNavController.setViewControllers(
            [UIViewController()],
            animated: false
        )

        let vc1 = UIViewController()
        let vc2 = UIViewController()
        let presentedNavController = UINavigationController()
        presentedNavController.setViewControllers(
            [vc1, vc2],
            animated: false
        )
        rootNavController.presentViewController(
            presentedNavController,
            animated: false,
            completion: nil
        )


        navigationRouter.popViewControllerOffStack()


        expect(presentedNavController.topViewController === vc1).to(beTrue())
    }
}
