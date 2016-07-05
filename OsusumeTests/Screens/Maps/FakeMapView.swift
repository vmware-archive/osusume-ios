@testable import Osusume

class FakeMapViewer: MapView {
    let mapView = MKMapView()

    var addAnnotation_wasCalled = false
    var addAnnotation_arg:MKAnnotation = MKPointAnnotation()
    func addAnnotation(annotation: MKAnnotation) {
        addAnnotation_arg = annotation
        addAnnotation_wasCalled = true
    }

    var setRegion_wasCalled = false
    var setRegion_args = (region: MKCoordinateRegion(), animated: false)
    func setRegion(region: MKCoordinateRegion, animated: Bool) {
        setRegion_args = (region: region, animated: animated)
        setRegion_wasCalled = true
    }
}
