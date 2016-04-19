import Foundation
import UIKit
import PureLayout
import BrightFutures

class RestaurantListViewController: UIViewController {
    // MARK: - Properties
    private unowned let router: Router
    private let repo: RestaurantRepo
    private let reloader: Reloader
    let restaurantListDataSource: RestaurantListDataSource

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
        self.restaurantListDataSource = RestaurantListDataSource(photoRepo: photoRepo)

        super.init(nibName: nil, bundle: nil)

        tableView.delegate = self
        tableView.dataSource = self.restaurantListDataSource
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantListViewController")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        repo.getAll()
            .onSuccess(ImmediateExecutionContext) { [unowned self] returnedRestaurants in
                self.restaurantListDataSource.myPosts = returnedRestaurants
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
                title: "Add restaurant",
                style: .Plain,
                target: self,
                action: Selector("didTapAddRestaurantButton:")
        )

        tableView.registerClass(
            RestaurantTableViewCell.self,
            forCellReuseIdentifier: String(RestaurantTableViewCell)
        )

        view.addSubview(tableView)
        applyViewConstraints()
    }

    // MARK: - Constraints
    func applyViewConstraints() {
        tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }

    // MARK: - Actions
    @objc private func didTapProfileButton(sender: UIBarButtonItem) {
        router.showProfileScreen()
    }

    @objc private func didTapAddRestaurantButton(sender: UIBarButtonItem) {
        router.showNewRestaurantScreen()
    }
}

// MARK: - UITableViewDelegate
extension RestaurantListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath
        )
    {
        let id = restaurantListDataSource.myPosts[indexPath.row].id
        router.showRestaurantDetailScreen(id)
    }
}
