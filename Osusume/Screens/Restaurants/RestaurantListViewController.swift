import Foundation
import UIKit
import PureLayout
import BrightFutures

class RestaurantListViewController: UIViewController {
    unowned let router: Router
    let repo: RestaurantRepo
    let reloader: Reloader
    let restaurantDataSource: RestaurantDataSource

    let cellIdentifier = "RestaurantListItemCell"

    // MARK: - View Elements
    let tableView = UITableView.newAutoLayoutView()

    // MARK: - Initializers
    init(
        router: Router,
        repo: RestaurantRepo,
        reloader: Reloader,
        photoRepo: PhotoRepo)
    {
        self.router = router
        self.repo = repo
        self.reloader = reloader
        self.restaurantDataSource = RestaurantDataSource(photoRepo: photoRepo)

        super.init(nibName: nil, bundle: nil)

        tableView.delegate = self
        tableView.dataSource = self.restaurantDataSource
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantListViewController")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        repo.getAll()
            .onSuccess(ImmediateExecutionContext) { [unowned self] returnedRestaurants in
                self.restaurantDataSource.myPosts = returnedRestaurants
                self.reloader.reload(self.tableView)
        }

        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                title: "Profile",
                style: .Plain,
                target: self,
                action: Selector("didTapProfileButton:"))

        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                title: "add restaurant",
                style: .Plain,
                target: self,
                action: Selector("didTapAddRestaurantButton:")
        )

        tableView.registerClass(
            RestaurantTableViewCell.self,
            forCellReuseIdentifier: cellIdentifier
        )

        view.addSubview(tableView)
        applyViewConstraints()
    }

    // MARK: - Constraints
    func applyViewConstraints() {
        tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }

    // MARK: - Actions
    func didTapProfileButton(sender: UIBarButtonItem) {
        router.showProfileScreen()
    }

    func didTapAddRestaurantButton(sender: UIBarButtonItem) {
        router.showNewRestaurantScreen()
    }

    func didTapRestaurant(id: Int) {
        router.showRestaurantDetailScreen(id)
    }
}

extension RestaurantListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath
        )
    {
        let id = restaurantDataSource.myPosts[indexPath.row].id

        didTapRestaurant(id)
    }
}
