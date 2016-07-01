class MapViewController: UIViewController {
    // MARK: - Properties
    let mapView: MKMapView

    // MARK: - Constants

    // MARK: - View Elements

    // MARK: - Initializers
    init() {
        // Initialization
        mapView = MKMapView()

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
        view.addSubview(mapView)
    }

    private func configureSubviews() {
        mapView.autoPinEdgesToSuperviewEdges()
    }

    private func addConstraints() {
    }

    // MARK: - Actions
    // MARK: - Private Methods
}
