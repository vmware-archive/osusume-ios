import Quick
import Nimble

@testable import Osusume

class NavigationRouterTest: QuickSpec {
    override func spec() {
        describe("the navigation router") {
            var navigationRouter: NavigationRouter!
            var navController: UINavigationController!
            let fakeSessionRepo = FakeSessionRepo()

            beforeEach {
                navController = UINavigationController()

                navigationRouter = NavigationRouter(
                    navigationController: navController,
                    sessionRepo: fakeSessionRepo,
                    restaurantRepo: FakeRestaurantRepo(),
                    photoRepo: FakePhotoRepo(),
                    userRepo: FakeUserRepo(),
                    commentRepo: FakeCommentRepo()
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
                let restaurant = Restaurant(
                    id: 1,
                    name: "Existing Restaurant",
                    address: "",
                    cuisineType: "つけめん",
                    offersEnglishMenu: true,
                    walkInsOk: true,
                    acceptsCreditCards: true,
                    notes: "This place is great",
                    author: "Simon",
                    createdAt: NSDate(timeIntervalSince1970: 1454480320),
                    photoUrl: NSURL(string: "")
                )

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
                navigationRouter.showNewCommentScreen(1)

                expect(navController.topViewController).to(beAKindOf(NewCommentViewController))
            }

            it("dismisses the new comment screen") {
                let fakeRestaurantRepo = FakeRestaurantRepo()
                fakeRestaurantRepo.createdRestaurant = Fixtures.newRestaurant()

                navigationRouter.navigationController.setViewControllers(
                    [
                        RestaurantDetailViewController(
                            router: FakeRouter(),
                            repo: fakeRestaurantRepo,
                            restaurantId: 2
                        ),
                        NewCommentViewController(
                            router: FakeRouter(),
                            commentRepo: FakeCommentRepo()
                        )
                    ],
                    animated: false
                )
                navigationRouter.dismissNewCommentScreen(false)

                expect(navController.topViewController).to(beAKindOf(RestaurantDetailViewController))
            }
        }
    }
}