import Foundation
import UIKit
import PureLayout
import BrightFutures

class RestaurantDetailViewController: UIViewController {
    unowned let router: Router
    let repo: RestaurantRepo

    let restaurantId: Int
    var restaurant: Restaurant? = nil

    //MARK: - View Elements
    let tableView = UITableView.newAutoLayoutView()

    //MARK: - Initializers
    init(
        router: Router,
        repo: RestaurantRepo,
        restaurantId: Int)
    {
        self.router = router
        self.repo = repo
        self.restaurantId = restaurantId

        super.init(nibName: nil, bundle: nil)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        tableView.registerClass(
            RestaurantDetailTableViewCell.self,
            forCellReuseIdentifier: String(RestaurantDetailTableViewCell)
        )

        let editButton = UIBarButtonItem(
            title: "Edit",
            style: .Plain,
            target: self,
            action: Selector("didTapEditRestaurantButton:")
        )
        navigationItem.rightBarButtonItem = editButton
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantDetailViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        applyViewConstraints()

        repo.getOne(self.restaurantId)
            .onSuccess(ImmediateExecutionContext) { [unowned self] returnedRestaurant in
                self.restaurant = returnedRestaurant
                self.tableView.reloadData()
        }
    }

    //MARK: - Actions
    func didTapEditRestaurantButton(sender: UIBarButtonItem) {
        if let currentRestaurant = self.restaurant {
            router.showEditRestaurantScreen(currentRestaurant)
        }
    }

    //MARK: - Constraints
    func applyViewConstraints() {
        tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
}

extension RestaurantDetailViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant != nil ? 1 : 0
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
        ) -> UITableViewCell
    {
        guard
            let cell = tableView.dequeueReusableCellWithIdentifier(
                String(RestaurantDetailTableViewCell), forIndexPath: indexPath
                ) as? RestaurantDetailTableViewCell,
            let currentRestaurant = restaurant else {
                return UITableViewCell()
        }

        cell.selectionStyle = .None
        cell.delegate = self
        cell.configureViewWithRestaurant(currentRestaurant)

        return cell
    }
}

extension RestaurantDetailViewController: UITableViewDelegate {
    func tableView(
        tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: NSIndexPath
        ) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}

extension RestaurantDetailViewController: RestaurantDetailTableViewCellDelegate {
    func displayAddCommentScreen() {
        router.showNewCommentScreen(self.restaurant!.id)
    }
}
