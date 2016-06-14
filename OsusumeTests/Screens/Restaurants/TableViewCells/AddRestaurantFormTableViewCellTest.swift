import XCTest
import Nimble
@testable import Osusume

class AddRestaurantFormTableViewCellTest: XCTestCase {

    var addRestaurantFormTVC: AddRestaurantFormTableViewCell!

    override func setUp() {
        addRestaurantFormTVC = AddRestaurantFormTableViewCell()
    }

    // MARK: - Initialize View
    func test_viewDidLoad_initializesSubviews() {
        expect(self.addRestaurantFormTVC.formView)
            .to(beAKindOf(NewRestaurantFormView))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.addRestaurantFormTVC.contentView)
            .to(containSubview(addRestaurantFormTVC.formView))
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.addRestaurantFormTVC.formView)
            .to(hasConstraintsToSuperview())
    }

    func test_cellDoesNotAppearSelected() {
        expect(self.addRestaurantFormTVC.selectionStyle == .None).to(beTrue())
    }
}
