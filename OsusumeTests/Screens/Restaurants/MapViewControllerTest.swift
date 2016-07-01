import XCTest
import Nimble
@testable import Osusume

class MapViewControllerTest: XCTestCase {
    var mapVC: MapViewController!

    override func setUp() {
        self.mapVC = MapViewController()
        self.mapVC.view.setNeedsLayout()
    }

    func test_viewDidLoad_initializesSubviews() {
        expect(self.mapVC.mapView).to(beAKindOf(MKMapView))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.mapVC.view).to(containSubview(mapVC.mapView))
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.mapVC.mapView).to(hasConstraintsToSuperviewOrSelf())
    }

    func test_viewDidLoad_setsTitle() {
        expect(self.mapVC.title).to(equal("Location"))
    }
}
