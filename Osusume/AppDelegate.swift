import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let router: NavigationRouter
    let sessionRepo: SessionRepo
    let photoRepo: PhotoRepo

    static let basePath = NSBundle.mainBundle().objectForInfoDictionaryKey("ServerURL") as! String

    convenience override init() {
        let navController = UINavigationController()
        let sessionRepo = SessionRepo()
        let photoRepo = S3PhotoRepo()
        let router: NavigationRouter = NavigationRouter(navigationController: navController, http: AlamofireHttp(basePath: AppDelegate.basePath, sessionRepo: sessionRepo), sessionRepo: sessionRepo)

        self.init(router: router, sessionRepo: sessionRepo, photoRepo: photoRepo)
    }

    init(router: NavigationRouter, sessionRepo: SessionRepo, photoRepo: PhotoRepo) {
        self.router = router
        self.sessionRepo = sessionRepo
        self.photoRepo = photoRepo
    }

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
        ) -> Bool {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            window!.rootViewController = router.navigationController
            window!.makeKeyAndVisible()

            LaunchWorkflow(sessionRepo: sessionRepo, photoRepo: photoRepo).startWorkflow(router)

            return true
    }
}
