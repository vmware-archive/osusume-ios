import Foundation
import UIKit
import PureLayout
import BrightFutures

class RestaurantListViewController: UITableViewController {

    unowned let router : Router
    let repo : Repo

    let cellIdentifier = "RestaurantListItemCell"
    var restaurants: [Restaurant] = []

    //MARK: - Initializers
    init(router: Router, repo: Repo) {
        self.router = router
        self.repo = repo

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantListViewController")
    }

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        repo.getAll()
            .onSuccess(ImmediateExecutionContext) { [unowned self] returnedRestaurants in
                self.restaurants = returnedRestaurants
                self.tableView.reloadData()
        }

        self.navigationItem.rightBarButtonItem =
                UIBarButtonItem(title: "add restaurant", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addRestaurantButtonTapped:"))
        self.navigationItem.rightBarButtonItem?.title = "add restaurant"

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    //MARK: - Actions
    func addRestaurantButtonTapped(sender: UIBarButtonItem) {
        router.showNewRestaurantScreen()
    }

    func listedRestaurantTapped(id: Int) {
        router.showRestaurantDetailScreen(id)
    }

    //MARK: - UITableView

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        cell.textLabel?.text = restaurants[indexPath.row].name
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let id = restaurants[indexPath.row].id
        self.listedRestaurantTapped(id)
    }
}
