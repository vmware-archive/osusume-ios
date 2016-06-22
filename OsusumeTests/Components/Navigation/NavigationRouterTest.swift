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
        rootNavController.pushViewController(UIViewController(), animated: false)


        navigationRouter.showNewRestaurantScreen()


        let newRestaurantNavController = rootNavController.presentedViewController as? UINavigationController
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
        rootNavController.pushViewController(UIViewController(), animated: false)


        let restaurant = RestaurantFixtures.newRestaurant()
        navigationRouter.showEditRestaurantScreen(restaurant)


        let editRestaurantNavController = rootNavController.presentedViewController as? UINavigationController
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
        configureUIWindowWithRootViewController(rootNavController)
        rootNavController.pushViewController(UIViewController(), animated: false)


        navigationRouter.showNewCommentScreen(1)


        let newCommentNavController = rootNavController.presentedViewController as? UINavigationController
        expect(newCommentNavController?.topViewController).to(beAKindOf(NewCommentViewController))
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


        navigationRouter.showFindCuisineScreen(newRestaurantVC)


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


        navigationRouter.showPriceRangeListScreen(newRestaurantVC)


        expect(newRestaurantNavVC.topViewController).to(beAKindOf(PriceRangeListViewController))
    }

    func test_showingFindRestaurantScreen_withNewViewController_isOK() {
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


        navigationRouter.showFindRestaurantScreen(newRestaurantVC)


        expect(newRestaurantNavVC.topViewController).to(beAKindOf(FindRestaurantViewController))
    }
    
    
    func test_showingFindRestaurantScreen_withEditViewController_isOK() {
        configureUIWindowWithRootViewController(rootNavController)
        rootNavController.setViewControllers(
            [UIViewController()],
            animated: false
        )
        let restaurant = RestaurantFixtures.newRestaurant(
            id: 5,
            name: "Pizzakaya",
            liked: false,
            cuisine: Cuisine(id: 1, name: "American"),
            notes: "The best pizza in Tokyo",
            createdByUser: (id: 99, name: "Witta", email: "witta@pivotal"),
            priceRange: PriceRange(id: 1, range: "Reasonable"),
            photoUrls: [
                PhotoUrl(id: 10, url: NSURL(string: "url")!)
            ]
        )
        let editRestaurantVC = EditRestaurantViewController(
            router: FakeRouter(),
            repo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            sessionRepo: fakeSessionRepo,
            reloader: FakeReloader(),
            restaurant: restaurant
        )
        let editRestaurantNavVC = UINavigationController(
            rootViewController: editRestaurantVC
        )
        
        rootNavController.presentViewController(
            editRestaurantNavVC,
            animated: false,
            completion: nil
        )
        
        
        navigationRouter.showFindRestaurantScreen(editRestaurantVC)
        
        
        expect(editRestaurantNavVC.topViewController).to(beAKindOf(FindRestaurantViewController))
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
