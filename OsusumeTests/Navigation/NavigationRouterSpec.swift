import Quick
import Nimble

@testable import Osusume

class NavigationRouterSpec : QuickSpec {
    override func spec() {
        describe("the navigation router") {
            var subject : NavigationRouter!
            var navController : UINavigationController!

            let http: Http = AlamofireHttp(basePath: AppDelegate.basePath)

            beforeEach {
                navController = UINavigationController()

                subject = NavigationRouter(navigationController: navController, http: http, sessionRepo: SessionRepo())
            }

            it("shows the new restaurant screen") {
                subject.showNewRestaurantScreen()

                expect(navController.topViewController).to(beAKindOf(NewRestaurantViewController))
            }

            it("shows the restaurant list screen") {
                subject.showRestaurantListScreen()

                expect(navController.topViewController).to(beAKindOf(RestaurantListViewController))
            }

            it("shows the restaurant detail screen") {
                subject.showRestaurantDetailScreen(1)
                expect(navController.topViewController).to(beAKindOf(RestaurantDetailViewController))
            }

            it("shows the edit restaurant screen") {
                let restaurant = Restaurant(id: 1, name: "Existing Restaurant")
                subject.showEditRestaurantScreen(restaurant)
                expect(navController.topViewController).to(beAKindOf(EditRestaurantViewController))
            }

        }
    }
}