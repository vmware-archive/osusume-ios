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
        let photoRepo = NetworkPhotoRepo(
            remoteStorage: S3Storage(),
            uuidProvider: RandomUUIDProvider(),
            localStorage: DiskStorage(),
            imageLoader: DefaultImageLoader()
        )

        let http = DefaultHttp(basePath: AppDelegate.basePath)
        let restaurantRepo = NetworkRestaurantRepo(
            http: http,
            sessionRepo: sessionRepo
        )
        let userRepo = NetworkUserRepo(
            http: http,
            sessionRepo: sessionRepo
        )
        let commentRepo = NetworkCommentRepo(
            http: http,
            sessionRepo: sessionRepo,
            parser: CommentParser()
        )
        let postRepo = NetworkPostRepo(
            restaurantRepo: NetworkRestaurantRepo(
                http: http,
                sessionRepo: sessionRepo,
                path: "/profile/posts"
            )
        )
        let cuisineRepo = HttpCuisineRepo(
            http: http,
            sessionRepo: sessionRepo,
            parser: CuisineListParser()
        )
        let likeRepo = NetworkLikeRepo(
            http: http,
            sessionRepo: sessionRepo
        )

        let router: NavigationRouter = NavigationRouter(
            navigationController: navController,
            sessionRepo: sessionRepo,
            restaurantRepo: restaurantRepo,
            photoRepo: photoRepo,
            userRepo: userRepo,
            commentRepo: commentRepo,
            postRepo: postRepo,
            cuisineRepo: cuisineRepo,
            likeRepo: likeRepo
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
