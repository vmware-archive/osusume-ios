import BrightFutures

class RestaurantDetailViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let reloader: Reloader
    private let restaurantRepo: RestaurantRepo
    private let likeRepo: LikeRepo
    private let sessionRepo: SessionRepo
    private let commentRepo: CommentRepo
    private let restaurantId: Int
    private(set) var restaurant: Restaurant?
    let currentUserId: Int?

    // MARK: - View Elements
    let tableView: UITableView

    // MARK: - Initializers
    init(
        router: Router,
        reloader: Reloader,
        restaurantRepo: RestaurantRepo,
        likeRepo: LikeRepo,
        sessionRepo: SessionRepo,
        commentRepo: CommentRepo,
        restaurantId: Int)
    {
        self.router = router
        self.reloader = reloader
        self.restaurantRepo = restaurantRepo
        self.likeRepo = likeRepo
        self.sessionRepo = sessionRepo
        self.commentRepo = commentRepo
        self.restaurantId = restaurantId
        self.currentUserId = sessionRepo.getAuthenticatedUser()?.id

        tableView = UITableView.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantDetailViewController")
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Restaurant Details"

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

                var maybeCell: UITableViewCell? =
                    tableView.dequeueReusableCellWithIdentifier(String(UITableViewCell))

                if (maybeCell == nil) {
                    maybeCell = UITableViewCell(
                        style: .Subtitle,
                        reuseIdentifier: String(UITableViewCell)
                    )
                }

                guard let cell = maybeCell else {
                    return UITableViewCell()
                }
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

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return isCommentPostedByCurrentUser(indexPath)
    }

    func tableView(
        tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let comment = restaurant!.comments[indexPath.row]
            restaurant!.comments.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.commentRepo.delete(comment.id)
        }
    }


    // MARK: - Private Methods
    private func isCommentPostedByCurrentUser(indexPath: NSIndexPath) -> Bool
    {
        guard
            indexPath.section == 1,
            let currentRestaurant = restaurant,
            let userId = currentUserId
            else {
                return false
        }
        return userId == currentRestaurant.comments[indexPath.row].userId
    }

    private func deleteCommentAtIndexPath(indexPath: NSIndexPath) {
        guard
            indexPath.section == 1 && restaurant != nil
        else {
            return
        }

        let comment = restaurant!.comments[indexPath.row]

        self.commentRepo.delete(comment.id)

        restaurant!.comments.removeAtIndex(indexPath.row)

        tableView.deleteRowsAtIndexPaths(
            [indexPath],
            withRowAnimation: .None
        )
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
                sender.enabled = false
        }
    }
}
