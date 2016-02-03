import Foundation
import UIKit
import PureLayout
import BrightFutures

class RestaurantListViewController: UITableViewController {

    unowned let router : Router
    let repo : RestaurantRepo

    let cellIdentifier = "RestaurantListItemCell"
    var restaurants: [Restaurant] = []
    let dateConverter = DateConverter()

    //MARK: - Initializers
    init(router: Router, repo: RestaurantRepo) {
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
                UIBarButtonItem(title: "add restaurant", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("didTapAddRestaurantButton:"))

        self.tableView.estimatedRowHeight = 10.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        tableView.registerClass(RestaurantTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    //MARK: - Actions
    func didTapAddRestaurantButton(sender: UIBarButtonItem) {
        router.showNewRestaurantScreen()
    }

    func didTapRestaurant(id: Int) {
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? RestaurantTableViewCell
        cell?.nameLabel.text = restaurants[indexPath.row].name
        cell?.cuisineTypeLabel.text = restaurants[indexPath.row].cuisineType
        cell?.authorLabel.text = "Added by \(restaurants[indexPath.row].author)"
        cell?.createdAtLabel.text = "Created on \(dateConverter.formattedDate(restaurants[indexPath.row].createdAt))"
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let id = restaurants[indexPath.row].id
        self.didTapRestaurant(id)
    }
}
