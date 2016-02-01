import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: NavigationRouter?
    var sessionRepo: SessionRepo?

    static let basePath = NSBundle.mainBundle().objectForInfoDictionaryKey("ServerURL") as! String

    convenience override init() {
        let navController = UINavigationController()
        let sessionRepo = SessionRepo()
        let router: NavigationRouter = NavigationRouter(navigationController: navController, http: AlamofireHttp(basePath: AppDelegate.basePath, sessionRepo: sessionRepo), sessionRepo: sessionRepo)

        self.init(router: router, sessionRepo: sessionRepo)
    }

    init(router: NavigationRouter, sessionRepo: SessionRepo) {
        self.router = router
        self.sessionRepo = sessionRepo
    }

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
        ) -> Bool {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            window!.rootViewController = router?.navigationController
            window!.makeKeyAndVisible()

            LaunchWorkflow(sessionRepo: sessionRepo!).startWorkflow(router!)

            return true
    }
}
