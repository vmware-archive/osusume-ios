import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let router: NavigationRouter
    let sessionRepo: SessionRepo
    let restaurantRepo: RestaurantRepo
    let photoRepo: PhotoRepo
    let userRepo: UserRepo

    static let basePath = NSBundle.mainBundle().objectForInfoDictionaryKey("ServerURL") as! String

    convenience override init() {
        let navController = UINavigationController()
        let sessionRepo = KeychainSessionRepo()
        let photoRepo = S3PhotoRepo()

        let http = AlamofireHttp(basePath: AppDelegate.basePath)
        let restaurantRepo = HttpRestaurantRepo(http: http, sessionRepo: sessionRepo)
        let userRepo = HttpUserRepo(http: http)

        let router: NavigationRouter = NavigationRouter(
            navigationController: navController,
            sessionRepo: sessionRepo,
            restaurantRepo: restaurantRepo,
            photoRepo: photoRepo,
            userRepo: userRepo
        )

        self.init(
            router: router,
            sessionRepo: sessionRepo,
            restaurantRepo: restaurantRepo,
            photoRepo: photoRepo,
            userRepo: userRepo
        )
    }

    init(
        router: NavigationRouter,
        sessionRepo: SessionRepo,
        restaurantRepo: RestaurantRepo,
        photoRepo: PhotoRepo,
        userRepo: UserRepo)
    {
        self.router = router
        self.sessionRepo = sessionRepo
        self.restaurantRepo = restaurantRepo
        self.photoRepo = photoRepo
        self.userRepo = userRepo
    }

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
        ) -> Bool {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            window!.rootViewController = router.navigationController
            window!.makeKeyAndVisible()

            LaunchWorkflow(sessionRepo: sessionRepo, photoRepo: photoRepo)
                .startWorkflow(router)

            return true
    }
}
