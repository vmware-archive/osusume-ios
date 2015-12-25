import Quick
import Nimble

@testable import Osusume

class NavigationRouterSpec : QuickSpec {
    override func spec() {
        describe("the navigation router") {
            var subject : NavigationRouter!
            var navController : UINavigationController!

            beforeEach {
                navController = UINavigationController()

                subject = NavigationRouter(navigationController: navController)
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
        }
    }
}