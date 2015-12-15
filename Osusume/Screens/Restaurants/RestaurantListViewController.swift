import Foundation
import UIKit
import PureLayout

class RestaurantListViewController : UITableViewController {

    unowned let router : Router

    let cellIdentifier = "RestaurantListItemCell"
    let restaurantNames: [String] = ["R1", "R2", "R3"]

    init(router: Router) {
        self.router = router

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantListViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return restaurantNames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        cell.textLabel?.text = restaurantNames[indexPath.row]
        return cell
    }
}
