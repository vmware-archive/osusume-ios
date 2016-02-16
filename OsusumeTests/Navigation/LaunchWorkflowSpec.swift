import Quick
import Nimble
import KeychainAccess

@testable import Osusume

class LaunchWorkflowSpec : QuickSpec {
    override func spec() {
        describe("the Launch Workflow") {
            var launchWorkflow: LaunchWorkflow!
            var router: NavigationRouter!
            var navController: UINavigationController!
            let fakeSessionRepo = FakeSessionRepo()
            let fakePhotoRepo = FakePhotoRepo()

            let http: Http = AlamofireHttp(
                basePath: AppDelegate.basePath,
                sessionRepo: fakeSessionRepo
            )

            beforeEach {
                navController = UINavigationController()

                router = NavigationRouter(
                    navigationController: navController,
                    http: http,
                    sessionRepo: fakeSessionRepo,
                    photoRepo: fakePhotoRepo
                )

                launchWorkflow = LaunchWorkflow(
                    sessionRepo: fakeSessionRepo,
                    photoRepo: fakePhotoRepo
                )
            }

            it("shows the login screen if there is no session") {
                launchWorkflow.startWorkflow(router)

                expect(navController.topViewController).to(beAKindOf(LoginViewController))
            }

            it("shows the restaurant list view screen if there is a session") {
                fakeSessionRepo.setToken("some-token")

                launchWorkflow.startWorkflow(router)

                expect(navController.topViewController).to(beAKindOf(RestaurantListViewController))
            }

            it("configures PhotoRepo") {
                launchWorkflow.startWorkflow(router)

                expect(fakePhotoRepo.configured).to(equal(true))
            }
        }
    }
}
