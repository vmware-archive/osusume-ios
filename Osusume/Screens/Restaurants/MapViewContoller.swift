class MapViewController: UIViewController {
    // MARK: - Properties
    let mapView: MapView
    let latitude: Double
    let longitude: Double

    // MARK: - Initializers
    init(latitude: Double, longitude: Double, mapView: MapView) {
        // Initialization
        self.mapView = mapView
        self.latitude = latitude
        self.longitude = longitude

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Location"

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()
    }

    // MARK: - View Setup
    private func configureNavigationBar() {
    }

    private func addSubviews() {
        view.addSubview(mapView.mapView)
    }

    private func configureSubviews() {
        let location = CLLocationCoordinate2DMake(self.latitude, self.longitude)

        let pin = MKPointAnnotation()
        pin.coordinate = location
        mapView.addAnnotation(pin)

        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: false)
    }

    private func addConstraints() {
        mapView.mapView.autoPinEdgesToSuperviewEdges()
    }
}
