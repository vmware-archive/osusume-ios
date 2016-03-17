import UIKit

class CuisineListTableViewController: UITableViewController {

    private let router: Router
    private let cuisineRepo: CuisineRepo
    private var cuisineList: CuisineList

    init(router: Router,
        cuisineRepo: CuisineRepo)
    {
        self.router = router
        self.cuisineRepo = cuisineRepo
        self.cuisineList = CuisineList(cuisines: [])

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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        title = "Add Cuisine"

        cuisineRepo.getAll()
            .onSuccess { [unowned self] cuisineList in
                self.cuisineList = cuisineList
                self.tableView.reloadData()
            }
    }

    // MARK: Actions
    func didTapCancelButton(sender: UIBarButtonItem?) {
        router.dismissFindCuisineScreen()
    }

    // MARK: UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuisineList.cuisines.count
    }

    override func tableView(
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
}
