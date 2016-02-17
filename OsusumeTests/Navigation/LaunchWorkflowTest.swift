import Quick
import Nimble
import KeychainAccess

@testable import Osusume

class LaunchWorkflowTest: QuickSpec {
    override func spec() {
        describe("the Launch Workflow") {
            var launchWorkflow: LaunchWorkflow!
            var router: NavigationRouter!
            var navController: UINavigationController!
            let fakeSessionRepo = FakeSessionRepo()
            let fakePhotoRepo = FakePhotoRepo()

            beforeEach {
                navController = UINavigationController()

                router = NavigationRouter(
                    navigationController: navController,
                    sessionRepo: FakeSessionRepo(),
                    restaurantRepo: FakeRestaurantRepo(),
                    photoRepo: fakePhotoRepo,
                    userRepo: FakeUserRepo(),
                    commentRepo: FakeCommentRepo()
                )

                launchWorkflow = LaunchWorkflow(
                    router: router,
                    sessionRepo: fakeSessionRepo,
                    photoRepo: fakePhotoRepo
                )
            }

            it("shows the login screen if there is no session") {
                launchWorkflow.startWorkflow()

                expect(navController.topViewController)
                    .to(beAKindOf(LoginViewController))
            }

            it("shows the restaurant list view screen if there is a session") {
                fakeSessionRepo.setToken("some-token")

                launchWorkflow.startWorkflow()

                expect(navController.topViewController)
                    .to(beAKindOf(RestaurantListViewController))
            }

            it("configures PhotoRepo") {
                launchWorkflow.startWorkflow()

                expect(fakePhotoRepo.configured).to(equal(true))
            }
        }
    }
}
