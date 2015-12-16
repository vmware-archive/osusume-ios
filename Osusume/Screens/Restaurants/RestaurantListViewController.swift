import Foundation
import UIKit
import PureLayout

class RestaurantListViewController : UITableViewController {

    unowned let router : Router
    let repo : Repo

    let cellIdentifier = "RestaurantListItemCell"
    var restaurants: [Restaurant] = []

    init(router: Router, repo: Repo) {
        self.router = router
        self.repo = repo

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantListViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        repo.getAll()
            .onSuccess { [unowned self] returnedRestaurants in
                self.restaurants = returnedRestaurants
                self.tableView.reloadData()
        }

        self.navigationItem.rightBarButtonItem =
                UIBarButtonItem(title: "add restaurant", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addRestaurantButtonTapped:"))
        self.navigationItem.rightBarButtonItem?.title = "add restaurant"

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    func addRestaurantButtonTapped(sender: UIBarButtonItem) {
        router.showNewRestaurantScreen()
    }

    //MARK: UITableView

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
}
