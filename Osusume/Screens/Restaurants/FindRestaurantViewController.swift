class FindRestaurantViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let reloader: Reloader
    private let restaurantSearchRepo: RestaurantSearchRepo
    private var restaurantResults: [SearchResultRestaurant]
    private let searchResultRestaurantSelectionDelegate: SearchResultRestaurantSelectionDelegate

    // MARK: - Constants

    // MARK: - View Elements
    let restaurantNameTextField: UITextField
    let restaurantSearchResultTableView: UITableView

    // MARK: - Initializers
    init(router: Router,
         restaurantSearchRepo: RestaurantSearchRepo,
         reloader: Reloader,
         searchResultRestaurantSelectionDelegate: SearchResultRestaurantSelectionDelegate
    ) {
        self.router = router
        self.restaurantSearchRepo = restaurantSearchRepo
        self.reloader = reloader
        restaurantResults = []
        self.searchResultRestaurantSelectionDelegate = searchResultRestaurantSelectionDelegate
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
        restaurantNameTextField.delegate = self

        restaurantSearchResultTableView.dataSource = self
        restaurantSearchResultTableView.delegate = self
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

    // MARK: - Private Methods
}

// MARK: - UITextFieldDelegate
extension FindRestaurantViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        restaurantSearchRepo.getForSearchTerm(textField.text!)
            .onSuccess { results in
                self.restaurantResults = results
                self.reloader.reload(self.restaurantSearchResultTableView)
            }
        return true
    }
}

// MARK: - UITableViewDataSource
extension FindRestaurantViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantResults.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) ->  UITableViewCell
    {
        var cell: UITableViewCell? =
            restaurantSearchResultTableView.dequeueReusableCellWithIdentifier(String(UITableViewCell))

        if (cell == nil) {
            cell = UITableViewCell(
                style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: String(UITableViewCell)
            )
        }

        guard let resultCell = cell else {
            return UITableViewCell()
        }

        resultCell.textLabel?.text = restaurantResults[indexPath.row].name
        resultCell.detailTextLabel?.text = restaurantResults[indexPath.row].address

        return resultCell
    }
}

// MARK: - UITableViewDelegate
extension FindRestaurantViewController: UITableViewDelegate {
    func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        searchResultRestaurantSelectionDelegate
            .searchResultRestaurantSelected(restaurantResults[indexPath.row])
        router.popViewControllerOffStack()
    }
}
