import Quick
import Nimble
import KeychainAccess

@testable import Osusume

class LaunchWorkflowSpec : QuickSpec {
    override func spec() {
        describe("the Launch Workflow") {
            var subject: LaunchWorkflow!
            var router: NavigationRouter!
            var navController: UINavigationController!
            let session: SessionRepo = SessionRepo()

            let http: Http = AlamofireHttp(basePath: AppDelegate.basePath, sessionRepo: session)

            beforeEach {
                navController = UINavigationController()
                router = NavigationRouter(navigationController: navController, http: http, sessionRepo: session)

                subject = LaunchWorkflow(sessionRepo: session)
            }

            it("logs shows the login screen if there is no session") {
                session.deleteToken()

                subject.startWorkflow(router)

                expect(navController.topViewController).to(beAKindOf(LoginViewController))
            }

            it("logs shows the restaurant list view screen if there is a session") {
                session.setToken("some-token")

                subject.startWorkflow(router)

                expect(navController.topViewController).to(beAKindOf(RestaurantListViewController))
            }
        }
    }
}