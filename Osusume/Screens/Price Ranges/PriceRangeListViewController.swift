class PriceRangeListViewController: UIViewController {
    // MARK: - Properties
    private let priceRangeRepo: PriceRangeRepo
    private let reloader: Reloader
    private var priceRanges: [PriceRange]
    private let router: Router
    private let priceRangeSelection: PriceRangeSelectionProtocol

    // MARK: - View Elements
    let tableView: UITableView

    // MARK: - Initializers
    init(
        priceRangeRepo: PriceRangeRepo,
        reloader: Reloader,
        router: Router,
        priceRangeSelection: PriceRangeSelectionProtocol
    ) {
        self.priceRangeRepo = priceRangeRepo
        self.reloader = reloader
        self.priceRanges = []
        self.router = router
        self.priceRangeSelection = priceRangeSelection

        self.tableView = UITableView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Price Range"

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()

        priceRangeRepo.getAll()
            .onSuccess { priceRanges in
                self.priceRanges = priceRanges
                self.reloader.reload(self.tableView)
            }
    }

    // MARK: - View Setup
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: Selector("didTapCancelButton:")
        )
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func configureSubviews() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerClass(
            UITableViewCell.self,
            forCellReuseIdentifier: String(UITableViewCell)
        )
    }

    private func addConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }

    // MARK: - Actions
    @objc private func didTapCancelButton(sender: UIBarButtonItem) {
        router.dismissPresentedNavigationController()
    }
}

// MARK: - UITableViewDataSource
extension PriceRangeListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceRanges.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(String(UITableViewCell))!

        cell.textLabel?.text = priceRanges[indexPath.row].range

        return cell
    }
}

// MARK: - UITableViewDelegate
extension PriceRangeListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = self.tableView(
            self.tableView,
            cellForRowAtIndexPath: indexPath
        )

        let selectedPriceRange = selectedCell.textLabel?.text
        priceRangeSelection.priceRangeSelected(selectedPriceRange!)
        router.dismissPresentedNavigationController()
    }
}
