import Foundation
import XCTest
import Nimble
import KeychainAccess

@testable import Osusume

class LaunchWorkflowTest: XCTestCase {

    var launchWorkflow: LaunchWorkflow!
    var navController: UINavigationController!
    let fakeSessionRepo = FakeSessionRepo()
    let fakePhotoRepo = FakePhotoRepo()

    override func setUp() {
        var router: NavigationRouter!

        navController = UINavigationController()

        router = NavigationRouter(
            navigationController: navController,
            sessionRepo: FakeSessionRepo(),
            restaurantRepo: FakeRestaurantRepo(),
            photoRepo: fakePhotoRepo,
            userRepo: FakeUserRepo(),
            commentRepo: FakeCommentRepo(),
            cuisineRepo: FakeCuisineRepo(),
            likeRepo: FakeLikeRepo(),
            priceRangeRepo: FakePriceRangeRepo()
        )

        launchWorkflow = LaunchWorkflow(
            router: router,
            sessionRepo: fakeSessionRepo,
            photoRepo: fakePhotoRepo
        )
    }

    func test_showsLoginScreen_whenASessionExists() {
        launchWorkflow.startWorkflow()

        expect(self.navController.topViewController)
            .to(beAKindOf(LoginViewController))
    }

    func test_showsRestaurantListView_whenASessionExists() {
        fakeSessionRepo.setToken("some-token")

        launchWorkflow.startWorkflow()

        expect(self.navController.topViewController)
            .to(beAKindOf(RestaurantListViewController))
    }
}
