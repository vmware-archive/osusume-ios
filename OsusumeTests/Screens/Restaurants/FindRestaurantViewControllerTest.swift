import XCTest
import Nimble
@testable import Osusume

class FindRestaurantViewControllerTest: XCTestCase {
    var findRestaurantViewController: FindRestaurantViewController!
    let fakeRouter = FakeRouter()

    override func setUp() {
        findRestaurantViewController = FindRestaurantViewController(
            router: fakeRouter
        )
        findRestaurantViewController.view.setNeedsLayout()
    }

    func test_viewDidLoad_initializesSubviews() {
        expect(self.findRestaurantViewController.restaurantNameTextField)
            .to(beAKindOf(UITextField))
        expect(self.findRestaurantViewController.restaurantSearchResultTableView)
            .to(beAKindOf(UITableView))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.findRestaurantViewController.view)
            .to(containSubview(findRestaurantViewController.restaurantNameTextField))
        expect(self.findRestaurantViewController.view)
            .to(containSubview(findRestaurantViewController.restaurantSearchResultTableView))
    }

    func test_viewDidAppear_setsRestaurantNameTextFieldAsFirstResponder() {
        var window: UIWindow?
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = findRestaurantViewController
        window!.makeKeyAndVisible()


        findRestaurantViewController.view.setNeedsLayout()
        NSRunLoop.osu_advance()


        expect(self.findRestaurantViewController.restaurantNameTextField.isFirstResponder())
            .to(beTrue())
    }

    func test_configureNavigationBar_addsBackButton() {
        expect(self.findRestaurantViewController.navigationItem.leftBarButtonItem?.title)
            .to(equal("Cancel"))
    }

    func test_tappingCancelButton_dismissesFindRestaurantVC() {
        let cancelButton = findRestaurantViewController.navigationItem.leftBarButtonItem!


        tapNavBarButton(cancelButton)


        expect(self.fakeRouter.dismissPresentedNavigationController_wasCalled).to(beTrue())
    }
}
