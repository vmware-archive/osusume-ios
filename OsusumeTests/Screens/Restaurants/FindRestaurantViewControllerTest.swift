import XCTest
import Nimble
@testable import Osusume

class FindRestaurantViewControllerTest: XCTestCase {

    func test_viewDidLoad_initializesSubviews() {
        let findRestaurantViewController = FindRestaurantViewController()
        findRestaurantViewController.view.setNeedsLayout()


        expect(findRestaurantViewController.restaurantNameTextField).to(beAKindOf(UITextField))
    }

    func test_viewDidLoad_addsSubviews() {
        let findRestaurantViewController = FindRestaurantViewController()
        findRestaurantViewController.view.setNeedsLayout()


        expect(findRestaurantViewController.view).to(containSubview(findRestaurantViewController.restaurantNameTextField))
    }

    func test_viewDidAppear_setsRestaurantNameTextFieldAsFirstResponder() {
        let findRestaurantViewController = FindRestaurantViewController()

        var window: UIWindow?
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = findRestaurantViewController
        window!.makeKeyAndVisible()

        findRestaurantViewController.view.setNeedsLayout()
        NSRunLoop.osu_advance()


        expect(findRestaurantViewController.restaurantNameTextField.isFirstResponder()).to(beTrue())
    }
}
