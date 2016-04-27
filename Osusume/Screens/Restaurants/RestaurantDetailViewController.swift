import Foundation
import UIKit
import PureLayout
import BrightFutures

class RestaurantDetailViewController: UIViewController {
    // MARK: - Properties
    private unowned let router: Router
    private let reloader: Reloader
    private let restaurantRepo: RestaurantRepo
    private let likeRepo: LikeRepo
    private let restaurantId: Int
    private var restaurant: Restaurant?

    // MARK: - View Elements
    let tableView: UITableView

    // MARK: - Initializers
    init(
        router: Router,
        reloader: Reloader,
        restaurantRepo: RestaurantRepo,
        likeRepo: LikeRepo,
        restaurantId: Int)
    {
        self.router = router
        self.reloader = reloader
        self.restaurantRepo = restaurantRepo
        self.likeRepo = likeRepo
        self.restaurantId = restaurantId

        tableView = UITableView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantDetailViewController")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        addSubviews()
        configureSubviews()
        addConstraints()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        restaurantRepo.getOne(self.restaurantId)
            .onSuccess(ImmediateExecutionContext) { [unowned self] returnedRestaurant in
                self.restaurant = returnedRestaurant
                self.reloader.reload(self.tableView)
        }
    }

    // MARK: - View Setup
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .Plain,
            target: self,
            action: #selector(RestaurantDetailViewController.didTapEditRestaurantButton(_:))
        )
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func configureSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        tableView.registerClass(
            RestaurantDetailTableViewCell.self,
            forCellReuseIdentifier: String(RestaurantDetailTableViewCell)
        )
        tableView.registerClass(
            UITableViewCell.self,
            forCellReuseIdentifier: String(UITableViewCell)
        )
    }

    private func addConstraints() {
        tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }

    // MARK: - Actions
    @objc private func didTapEditRestaurantButton(sender: UIBarButtonItem) {
        if let currentRestaurant = self.restaurant {
            router.showEditRestaurantScreen(currentRestaurant)
        }
    }
}

// MARK: - UITableViewDataSource
extension RestaurantDetailViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return restaurant != nil ? 1 : 0
            case 1:
                return restaurant?.comments.count ?? 0
            default:
                return 0
        }
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
        ) -> UITableViewCell
    {
        switch indexPath.section {
            case 0:
                guard
                    let cell = tableView.dequeueReusableCellWithIdentifier(
                        String(RestaurantDetailTableViewCell),
                        forIndexPath: indexPath
                    ) as? RestaurantDetailTableViewCell,

                    let currentRestaurant = restaurant else {
                        return UITableViewCell()
                }

                cell.backgroundColor = UIColor.cyanColor()
                cell.selectionStyle = .None
                cell.delegate = self
                cell.configureView(currentRestaurant, reloader: DefaultReloader(), router: router)

                return cell

            case 1:
                guard
                    let currentRestaurant = restaurant else {
                        return UITableViewCell()
                }

                let cell = UITableViewCell(
                    style: .Subtitle,
                    reuseIdentifier: String(UITableViewCell)
                )
                cell.backgroundColor = UIColor.greenColor()
                cell.selectionStyle = .None

                let comments = currentRestaurant.comments
                let currentComment = comments[indexPath.row]
                let createdDateString = DateConverter.formattedDate(currentComment.createdDate)

                cell.textLabel?.text = currentComment.text
                cell.detailTextLabel?.text = String("\(currentComment.userName) - \(createdDateString)")

                return cell

            default:
                return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension RestaurantDetailViewController: UITableViewDelegate {
    func tableView(
        tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: NSIndexPath
        ) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}

// MARK: - RestaurantDetailTableViewCellDelegate
extension RestaurantDetailViewController: RestaurantDetailTableViewCellDelegate {
    @objc func displayAddCommentScreen(sender: UIButton) {
        router.showNewCommentScreen(self.restaurant!.id)
    }

    @objc func didTapLikeButton(sender: UIButton) {
        likeRepo.like(restaurantId)
            .onSuccess { _ in
                sender.backgroundColor = UIColor.redColor()
                sender.setTitleColor(UIColor.blueColor(), forState: .Normal)
        }
    }
}
