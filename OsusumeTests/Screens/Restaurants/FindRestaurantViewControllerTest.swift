import XCTest
import Nimble
@testable import Osusume

class FindRestaurantViewControllerTest: XCTestCase {

    func test_viewDidLoad_showsRestaurantNameTextField() {
        let findRestaurantViewController = FindRestaurantViewController()
        findRestaurantViewController.view.setNeedsLayout()


        expect(findRestaurantViewController.restaurantNameTextField).to(beAKindOf(UITextField))
    }
}