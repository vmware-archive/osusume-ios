import Quick
import Nimble

@testable import Osusume

class NavigationRouterSpec: QuickSpec {
    override func spec() {
        describe("the navigation router") {
            var navigationRouter: NavigationRouter!
            var navController: UINavigationController!
            let fakeSessionRepo = FakeSessionRepo()

            let http: Http = AlamofireHttp(
                basePath: AppDelegate.basePath,
                sessionRepo: fakeSessionRepo
            )

            beforeEach {
                navController = UINavigationController()

                navigationRouter = NavigationRouter(
                    navigationController: navController,
                    http: http,
                    sessionRepo: fakeSessionRepo,
                    photoRepo: FakePhotoRepo()
                )
            }

            it("shows the new restaurant screen") {
                navigationRouter.showNewRestaurantScreen()

                expect(navController.topViewController).to(beAKindOf(NewRestaurantViewController))
            }

            it("shows the restaurant list screen") {
                navigationRouter.showRestaurantListScreen()

                expect(navController.topViewController).to(beAKindOf(RestaurantListViewController))
            }

            it("shows the restaurant detail screen") {
                navigationRouter.showRestaurantDetailScreen(1)
                expect(navController.topViewController).to(beAKindOf(RestaurantDetailViewController))
            }

            it("shows the edit restaurant screen") {
                let restaurant = Restaurant(id: 1, name: "Existing Restaurant")
                navigationRouter.showEditRestaurantScreen(restaurant)
                expect(navController.topViewController).to(beAKindOf(EditRestaurantViewController))
            }

            it("shows the login screen") {
                navigationRouter.showLoginScreen()
                expect(navController.topViewController).to(beAKindOf(LoginViewController))
            }

            it("passes the session to the login screen") {
                navigationRouter.showLoginScreen()

                let loginVC = navController.topViewController as! LoginViewController
                let loginSessionRepo = loginVC.sessionRepo as? FakeSessionRepo
                expect(fakeSessionRepo === loginSessionRepo).to(beTrue())
            }

            it("shows the new comment screen") {
                let restaurant = Restaurant(id: 1, name: "Existing Restaurant")
                navigationRouter.showNewCommentScreen(1)

                expect(navController.topViewController).to(beAKindOf(NewCommentViewController))
            }
        }
    }
}