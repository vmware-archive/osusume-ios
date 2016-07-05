protocol MapView {
    var mapView: MKMapView { get }
    func addAnnotation(annotation: MKAnnotation)
    func setRegion(region: MKCoordinateRegion, animated: Bool)
}
