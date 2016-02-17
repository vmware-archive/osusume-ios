import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let router: NavigationRouter
    let sessionRepo: SessionRepo
    let photoRepo: PhotoRepo

    static let basePath = NSBundle.mainBundle().objectForInfoDictionaryKey("ServerURL") as! String

    convenience override init() {
        let navController = UINavigationController()
        let sessionRepo = KeychainSessionRepo()
        let photoRepo = S3PhotoRepo()

        let http = AlamofireHttp(basePath: AppDelegate.basePath)
        let restaurantRepo = HttpRestaurantRepo(
            http: http,
            sessionRepo: sessionRepo
        )
        let userRepo = HttpUserRepo(http: http)
        let commentRepo = HttpCommentRepo(http: http)

        let router: NavigationRouter = NavigationRouter(
            navigationController: navController,
            sessionRepo: sessionRepo,
            restaurantRepo: restaurantRepo,
            photoRepo: photoRepo,
            userRepo: userRepo,
            commentRepo: commentRepo
        )

        self.init(
            router: router,
            sessionRepo: sessionRepo,
            photoRepo: photoRepo
        )
    }

    init(
        router: NavigationRouter,
        sessionRepo: SessionRepo,
        photoRepo: PhotoRepo)
    {
        self.router = router
        self.sessionRepo = sessionRepo
        self.photoRepo = photoRepo
    }

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
        ) -> Bool
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        window?.rootViewController = router.navigationController
        window?.makeKeyAndVisible()

        let launchWorkflow = LaunchWorkflow(
            router: router,
            sessionRepo: sessionRepo,
            photoRepo: photoRepo
        )
        launchWorkflow.startWorkflow()

        return true
    }
}
