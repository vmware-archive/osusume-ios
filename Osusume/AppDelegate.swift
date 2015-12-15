import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: NavigationRouter?

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let navController = UINavigationController()

        router = NavigationRouter(navigationController: navController)

        router!.showRestaurantListScreen()

        window!.rootViewController = router!.navigationController
        window!.makeKeyAndVisible()

        return true
    }
}
