import Foundation
import UIKit
import PureLayout
import BrightFutures

class RestaurantListViewController: UIViewController {
    unowned let router: Router
    let repo: RestaurantRepo
    let reloader: Reloader
    let photoRepo: PhotoRepo

    let cellIdentifier = "RestaurantListItemCell"
    var restaurants: [Restaurant] = []

    //MARK: - View Elements
    let tableView = UITableView.newAutoLayoutView()

    //MARK: - Initializers
    init(
        router: Router,
        repo: RestaurantRepo,
        reloader: Reloader,
        photoRepo: PhotoRepo)
    {
        self.router = router
        self.repo = repo
        self.reloader = reloader
        self.photoRepo = photoRepo

        super.init(nibName: nil, bundle: nil)

        tableView.delegate = self
        tableView.dataSource = self
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

    //MARK: - Constraints
    func applyViewConstraints() {
        tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }

    //MARK: - Actions
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
}

extension RestaurantListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int
    {
        return restaurants.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
        ) -> UITableViewCell
    {
        if
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
                as? RestaurantTableViewCell
        {
            let presenter = RestaurantDetailPresenter(
                restaurant: restaurants[indexPath.row]
            )

            cell.photoImageView.image = UIImage(named: "TableCellPlaceholder")
            photoRepo.loadImageFromUrl(presenter.photoUrl)
                .onSuccess { image in
                    cell.photoImageView.image = image
                }

            cell.nameLabel.text = presenter.name
            cell.cuisineTypeLabel.text = presenter.cuisineType
            cell.authorLabel.text = presenter.author
            cell.createdAtLabel.text = presenter.creationDate

            return cell
        }

        return UITableViewCell()
    }

    func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath
        )
    {
        let id = restaurants[indexPath.row].id
        self.didTapRestaurant(id)
    }
}
