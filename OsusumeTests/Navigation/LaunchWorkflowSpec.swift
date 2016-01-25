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
            var session: SessionRepo!

            let http: Http = AlamofireHttp(basePath: AppDelegate.basePath)

            beforeEach {
                navController = UINavigationController()
                router = NavigationRouter(navigationController: navController, http: http)

                session = SessionRepo()
                subject = LaunchWorkflow(sessionRepo: session)
            }

            it("logs shows the restaurant list view screen if there is a session") {
                session.setToken("some-token")

                subject.startWorkflow(router)

                expect(navController.topViewController).to(beAKindOf(RestaurantListViewController))
            }
        }
    }
}