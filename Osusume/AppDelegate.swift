import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let router: NavigationRouter
    let sessionRepo: SessionRepo
    let restaurantRepo: RestaurantRepo
    let photoRepo: PhotoRepo

    static let basePath = NSBundle.mainBundle().objectForInfoDictionaryKey("ServerURL") as! String

    convenience override init() {
        let navController = UINavigationController()
        let sessionRepo = KeychainSessionRepo()
        let photoRepo = S3PhotoRepo()

        let http = AlamofireHttp(basePath: AppDelegate.basePath)
        let restaurantRepo = HttpRestaurantRepo(http: http, sessionRepo: sessionRepo)

        let router: NavigationRouter = NavigationRouter(
            navigationController: navController,
            http: http,
            sessionRepo: sessionRepo,
            restaurantRepo: restaurantRepo,
            photoRepo: photoRepo
        )

        self.init(
            router: router,
            sessionRepo: sessionRepo,
            restaurantRepo: restaurantRepo,
            photoRepo: photoRepo
        )
    }

    init(
        router: NavigationRouter,
        sessionRepo: SessionRepo,
        restaurantRepo: RestaurantRepo,
        photoRepo: PhotoRepo)
    {
        self.router = router
        self.sessionRepo = sessionRepo
        self.restaurantRepo = restaurantRepo
        self.photoRepo = photoRepo
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
