import Foundation
import UIKit
import PureLayout
import BrightFutures

class RestaurantListViewController: UITableViewController {
    unowned let router: Router
    let repo: RestaurantRepo
    let sessionRepo: SessionRepo

    let cellIdentifier = "RestaurantListItemCell"
    var restaurants: [Restaurant] = []

    //MARK: - Initializers
    init(router: Router, repo: RestaurantRepo, sessionRepo: SessionRepo) {
        self.router = router
        self.repo = repo
        self.sessionRepo = sessionRepo

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

        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                title: "Logout",
                style: .Plain,
                target: self,
                action: Selector("didTapLogoutButton:"))

        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                title: "add restaurant",
                style: .Plain,
                target: self,
                action: Selector("didTapAddRestaurantButton:")
        )

        self.tableView.estimatedRowHeight = 10.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        tableView.registerClass(
            RestaurantTableViewCell.self,
            forCellReuseIdentifier: cellIdentifier
        )
    }

    //MARK: - Actions
    func didTapLogoutButton(sender: UIBarButtonItem) {
        sessionRepo.deleteToken()
        router.showLoginScreen()
    }

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

    override func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int
    {
        return restaurants.count
    }

    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
        ) -> UITableViewCell
    {
        if
            let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
                as? RestaurantTableViewCell
        {
            let presenter = RestaurantDetailPresenter(
                restaurant: restaurants[indexPath.row]
            )

            cell.nameLabel.text = presenter.name
            cell.cuisineTypeLabel.text = presenter.cuisineType
            cell.authorLabel.text = presenter.author
            cell.createdAtLabel.text = presenter.creationDate

            return cell
        }

        return UITableViewCell()
    }

    override func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath
        )
    {
        let id = restaurants[indexPath.row].id
        self.didTapRestaurant(id)
    }
}
