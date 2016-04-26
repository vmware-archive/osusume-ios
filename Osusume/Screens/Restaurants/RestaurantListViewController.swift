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
    let tableView: UITableView

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

        tableView = UITableView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantListViewController")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()

        repo.getAll()
            .onSuccess(ImmediateExecutionContext) { [unowned self] returnedRestaurants in
                self.restaurantListDataSource.updateRestaurants(returnedRestaurants)
                self.reloader.reload(self.tableView)
        }
    }

    // MARK: - View Setup
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Profile",
            style: .Plain,
            target: self,
            action: Selector("didTapProfileButton:")
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add restaurant",
            style: .Plain,
            target: self,
            action: Selector("didTapAddRestaurantButton:")
        )
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func configureSubviews() {
        tableView.dataSource = self.restaurantListDataSource
        tableView.delegate = self
        tableView.registerClass(
            RestaurantTableViewCell.self,
            forCellReuseIdentifier: String(RestaurantTableViewCell)
        )
    }

    private func addConstraints() {
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
    func tableView(
        tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100.0
    }

    func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let id = restaurantListDataSource.myPosts[indexPath.row].id
        router.showRestaurantDetailScreen(id)
    }
}
