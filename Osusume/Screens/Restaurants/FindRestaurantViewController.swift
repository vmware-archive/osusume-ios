class FindRestaurantViewController: UIViewController {
    // MARK: - Properties
    private let router: Router

    // MARK: - Constants

    // MARK: - View Elements
    let restaurantNameTextField: UITextField
    let restaurantSearchResultTableView: UITableView

    // MARK: - Initializers
    init(router: Router) {
        self.router = router
        self.restaurantSearchResultTableView = UITableView()

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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        restaurantNameTextField.becomeFirstResponder()
    }

    // MARK: - View Setup
    private func configureNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .Plain,
            target: self,
            action: #selector(FindRestaurantViewController.didTapCancelButton(_:))
        )
    }

    private func addSubviews() {
        view.addSubview(restaurantNameTextField)
        view.addSubview(restaurantSearchResultTableView)
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

        restaurantSearchResultTableView.autoPinEdge(
            .Top,
            toEdge: .Bottom,
            ofView: restaurantNameTextField,
            withOffset: 10.0
        )
        restaurantSearchResultTableView.autoPinEdgeToSuperviewEdge(.Left)
        restaurantSearchResultTableView.autoPinEdgeToSuperviewEdge(.Right)
        restaurantSearchResultTableView.autoPinEdgeToSuperviewEdge(.Bottom)
    }

    // MARK: - Actions
    @objc private func didTapCancelButton(sender: UIBarButtonItem?) {
        router.dismissPresentedNavigationController()
    }

    // MARK: - Private Methods

}
