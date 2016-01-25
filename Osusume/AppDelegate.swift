import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: NavigationRouter?
    var sessionRepo: SessionRepo = SessionRepo()


    convenience override init() {
        let navController = UINavigationController()

        self.init(router: router)
    }

    init(router: NavigationRouter) {
        self.router = router
    }

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
        ) -> Bool {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            window!.rootViewController = router?.navigationController
            window!.makeKeyAndVisible()

            LaunchWorkflow(sessionRepo: sessionRepo).startWorkflow(router!)

            return true
    }
}
