import UIKit

protocol CuisineSelectionProtocol {
    func cuisineSelected(cuisine: Cuisine)
}

class CuisineListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let router: Router
    let tableView: UITableView
    let cuisineRepo: CuisineRepo
    var cuisineList: CuisineList
    var delegate: CuisineSelectionProtocol?

    init(router: Router, cuisineRepo: CuisineRepo) {
        self.router = router
        self.cuisineRepo = cuisineRepo
        self.cuisineList = CuisineList(cuisines: [])
        self.tableView = UITableView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)

        let cancelButton: UIBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Cancel,
            target: self,
            action: Selector("didTapCancelButton:")
        )
        navigationItem.leftBarButtonItem = cancelButton

        tableView.registerClass(
            UITableViewCell.self,
            forCellReuseIdentifier: "CuisineCell"
        )
        tableView.dataSource = self
        tableView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        title = "Add Cuisine"

        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()

        cuisineRepo.getAll()
            .onSuccess { [unowned self] cuisineList in
                self.cuisineList = cuisineList
                self.tableView.reloadData()
            }
    }

    // MARK: - Actions
    func didTapCancelButton(sender: UIBarButtonItem?) {
        router.dismissFindCuisineScreen()
    }

    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuisineList.cuisines.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "CuisineCell",
            forIndexPath: indexPath
        )

        cell.textLabel?.text = cuisineList.cuisines[indexPath.row].name

        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        delegate?.cuisineSelected(cuisineList.cuisines[indexPath.row])
        router.dismissFindCuisineScreen()
    }
}

