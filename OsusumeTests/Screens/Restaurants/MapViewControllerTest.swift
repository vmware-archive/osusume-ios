import XCTest
import Nimble
@testable import Osusume

class MapViewControllerTest: XCTestCase {
    var mapVC: MapViewController!
    let fakeMapViewer = FakeMapViewer()

    override func setUp() {
        self.mapVC = MapViewController(latitude: 1.23, longitude: 2.34, mapView: fakeMapViewer)
        self.mapVC.view.setNeedsLayout()
    }

    func test_viewDidLoad_initializesSubviews() {
        expect(self.mapVC.mapView.mapView).to(beAKindOf(MKMapView))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.mapVC.view).to(containSubview(mapVC.mapView.mapView))
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.mapVC.mapView.mapView).to(hasConstraintsToSuperviewOrSelf())
    }

    func test_viewDidLoad_setsTitle() {
        expect(self.mapVC.title).to(equal("Location"))
    }

    // MARK: Map View
    func test_viewDidLoad_addsPinAtLocation() {
        expect(self.fakeMapViewer.addAnnotation_wasCalled).to(beTrue())
        expect(self.fakeMapViewer.addAnnotation_arg.coordinate.latitude).to(equal(1.23))
        expect(self.fakeMapViewer.addAnnotation_arg.coordinate.longitude).to(equal(2.34))
    }

    func test_viewDidLoad_centresMapOnLocation() {
        expect(self.fakeMapViewer.setRegion_wasCalled).to(beTrue())
        expect(self.fakeMapViewer.setRegion_args.region.center.latitude).to(equal(1.23))
        expect(self.fakeMapViewer.setRegion_args.region.center.longitude).to(equal(2.34))
        expect(self.fakeMapViewer.setRegion_args.region.span.latitudeDelta).to(equal(0.2))
        expect(self.fakeMapViewer.setRegion_args.region.span.longitudeDelta).to(equal(0.2))
    }
}
