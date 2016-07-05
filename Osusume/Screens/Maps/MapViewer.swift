class MapViewer: MapView {
    let mapView: MKMapView

    init() {
        self.mapView = MKMapView()
    }

    func addAnnotation(annotation: MKAnnotation) {
        self.mapView.addAnnotation(annotation)
    }

    func setRegion(region: MKCoordinateRegion, animated: Bool) {
        self.mapView.setRegion(region, animated: animated)
    }
}
