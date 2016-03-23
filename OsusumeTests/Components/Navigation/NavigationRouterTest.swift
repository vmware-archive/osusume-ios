import Foundation
import Nimble
import XCTest

@testable import Osusume

class NavigationRouterTest: XCTestCase {

    var navigationRouter: NavigationRouter!
    var navController: UINavigationController!
    var fakeSessionRepo: FakeSessionRepo!
    var fakeCuisineRepo: FakeCuisineRepo!

    override func setUp() {
        navController = UINavigationController()
        fakeSessionRepo = FakeSessionRepo()
        fakeCuisineRepo = FakeCuisineRepo()

        navigationRouter = NavigationRouter(
            navigationController: navController,
            sessionRepo: fakeSessionRepo,
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: FakePhotoRepo(),
            userRepo: FakeUserRepo(),
            commentRepo: FakeCommentRepo(),
            postRepo: FakePostRepo(),
            cuisineRepo: fakeCuisineRepo,
            likeRepo: FakeLikeRepo()
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
        let loginSessionRepo = loginVC.sessionRepo as! FakeSessionRepo

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
        expect(cuisineNavController?.topViewController).to(beAKindOf(CuisineListViewController))
    }

    func test_showingCuisineListScreen_setsDelegate() {
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
        let cuisineTVC = cuisineNavController?.topViewController as? CuisineListViewController
        expect(cuisineTVC?.cuisineSelectionDelegate).toNot(beNil())
    }

    func test_dismissesCuisineListScreen() {
        var window: UIWindow?
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = navController
        window!.makeKeyAndVisible()

        let cuisineNavController = UINavigationController()
        cuisineNavController.setViewControllers(
            [
                    CuisineListViewController(
                    router: FakeRouter(),
                    cuisineRepo: FakeCuisineRepo(),
                    textSearch: FakeTextSearch(),
                    reloader: FakeReloader()
                )
            ],
            animated: false
        )

        navController.pushViewController(UIViewController(), animated: false)
        navController.presentViewController(
            cuisineNavController,
            animated: false,
            completion: nil
        )

        let presentedViewController = navController.presentedViewController as? UINavigationController
        expect(presentedViewController?.topViewController).to(beAKindOf(CuisineListViewController))


        navigationRouter.dismissFindCuisineScreen()


        NSRunLoop.osu_advance(by: 1)
        expect(self.navController.presentedViewController).to(beNil())
    }
}
