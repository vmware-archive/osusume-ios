class FindRestaurantViewController: UIViewController {
    // MARK: - Properties

    // MARK: - Constants

    // MARK: - View Elements
    let restaurantNameTextField: UITextField

    // MARK: - Initializers
    init() {
        restaurantNameTextField = UITextField.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Find a restaurant"
        view.backgroundColor = UIColor.whiteColor()

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()
    }

    // MARK: - View Setup
    private func configureNavigationBar() {
    }

    private func addSubviews() {
        view.addSubview(restaurantNameTextField)
    }

    private func configureSubviews() {
        restaurantNameTextField.borderStyle = .Line
        restaurantNameTextField.autocapitalizationType = .None
        restaurantNameTextField.autocorrectionType = .No
        restaurantNameTextField.placeholder = "Restaurant name"
        restaurantNameTextField.backgroundColor = UIColor.lightGrayColor()
    }

    private func addConstraints() {
        restaurantNameTextField.autoPinToTopLayoutGuideOfViewController(self, withInset: 10.0)
        restaurantNameTextField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
        restaurantNameTextField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)
        restaurantNameTextField.autoSetDimension(.Height, toSize: 40.0)
    }

    // MARK: - Actions
    // MARK: - Private Methods
}
