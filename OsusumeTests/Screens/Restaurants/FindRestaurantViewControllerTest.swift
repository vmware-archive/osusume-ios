import XCTest
import Nimble
@testable import Osusume

class FindRestaurantViewControllerTest: XCTestCase {
    var findRestaurantViewController: FindRestaurantViewController!

    override func setUp() {
        findRestaurantViewController = FindRestaurantViewController()
        findRestaurantViewController.view.setNeedsLayout()
    }

    func test_viewDidLoad_initializesSubviews() {
        expect(self.findRestaurantViewController.restaurantNameTextField)
            .to(beAKindOf(UITextField))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.findRestaurantViewController.view)
            .to(containSubview(findRestaurantViewController.restaurantNameTextField))
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
}
