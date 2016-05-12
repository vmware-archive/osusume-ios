class FindRestaurantViewController: UIViewController {
    // MARK: - Properties

    // MARK: - Constants

    // MARK: - View Elements

    // MARK: - Initializers
    init() {
        // Initialization

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()
    }

    // MARK: - View Setup
    private func configureNavigationBar() {
    }

    private func addSubviews() {
    }

    private func configureSubviews() {
    }

    private func addConstraints() {
    }

    // MARK: - Actions
    // MARK: - Private Methods
}
