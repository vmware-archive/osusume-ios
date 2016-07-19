import XCTest
import Nimble
@testable import Osusume

class NearestStationTableViewCellTest: XCTestCase {

    var nearestStationTVC: NearestStationTableViewCell!

    override func setUp() {
        nearestStationTVC = NearestStationTableViewCell()
    }

    // MARK: - Initialize View
    func test_viewDidLoad_initializesSubviews() {
        expect(self.nearestStationTVC.titleLabel)
            .to(beAKindOf(UILabel))
        expect(self.nearestStationTVC.textField)
            .to(beAKindOf(UITextField))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.nearestStationTVC)
            .to(containSubview(nearestStationTVC.titleLabel))
        expect(self.nearestStationTVC)
            .to(containSubview(nearestStationTVC.textField))
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.nearestStationTVC.titleLabel)
            .to(hasConstraintsToSuperview())
        expect(self.nearestStationTVC.textField)
            .to(hasConstraintsToSuperview())
    }

    func test_viewDidLoad_configuresSubviews() {
        expect(self.nearestStationTVC.titleLabel.text)
            .to(equal("Nearest Station"))
        expect(self.nearestStationTVC.textField.placeholder)
            .to(equal("e.g. Roppongi Station"))
    }

    func test_cellDoesNotAppearSelected() {
        expect(self.nearestStationTVC.selectionStyle == .None)
            .to(beTrue())
    }
}