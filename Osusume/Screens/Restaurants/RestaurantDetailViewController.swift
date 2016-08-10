import BrightFutures

enum RestaurantDetailTableViewSections: Int {
    case PhotosSection = 0
    case DetailsSection
    case CommentsSection
    case Count

    static var count: Int {
        get {
            return RestaurantDetailTableViewSections.Count.rawValue
        }
    }
}

class RestaurantDetailViewController: UIViewController {
    // MARK: - Properties
    private let router: Router
    private let reloader: Reloader
    private let restaurantRepo: RestaurantRepo
    private let likeRepo: LikeRepo
    private let sessionRepo: SessionRepo
    private let commentRepo: CommentRepo
    private let restaurantId: Int
    private(set) var maybeRestaurant: Restaurant?
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
                self.maybeRestaurant = returnedRestaurant
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
            RestaurantPhotoTableViewCell.self,
            forCellReuseIdentifier: String(RestaurantPhotoTableViewCell)
        )
    }

    private func addConstraints() {
        tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }

    // MARK: - Actions
    @objc private func didTapEditRestaurantButton(sender: UIBarButtonItem) {
        if let currentRestaurant = self.maybeRestaurant {
            router.showEditRestaurantScreen(currentRestaurant)
        }
    }
}

// MARK: - UITableViewDataSource
extension RestaurantDetailViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return RestaurantDetailTableViewSections.Count.rawValue
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let restaurant = maybeRestaurant else {
            return 0
        }

        switch section {
            case RestaurantDetailTableViewSections.PhotosSection.rawValue:
                return restaurant.photoUrls.count > 0 ? 1 : 0

            case RestaurantDetailTableViewSections.DetailsSection.rawValue:
                return 1

            case RestaurantDetailTableViewSections.CommentsSection.rawValue:
                return restaurant.comments.count

            default:
                return 0
        }
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let restaurant = maybeRestaurant!

        switch indexPath.section {
            case RestaurantDetailTableViewSections.PhotosSection.rawValue:
                return initRestaurantPhotoTableViewCell(indexPath)

            case RestaurantDetailTableViewSections.DetailsSection.rawValue:
                return initRestaurantDetailTableViewCell(
                    indexPath,
                    restaurant: restaurant
                )

            case RestaurantDetailTableViewSections.CommentsSection.rawValue:
                let comment = restaurant.comments[indexPath.row]

                return initSubtitleTableViewCellForComment(comment)

            default:
                return UITableViewCell()
        }
    }

    private func initRestaurantDetailTableViewCell(indexPath: NSIndexPath,
                                                   restaurant: Restaurant) -> RestaurantDetailTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            String(RestaurantDetailTableViewCell),
            forIndexPath: indexPath
        ) as! RestaurantDetailTableViewCell

        cell.backgroundColor = UIColor.cyanColor()
        cell.selectionStyle = .None
        cell.delegate = self
        cell.configureView(restaurant, reloader: reloader, router: router)

        return cell
    }

    private func initRestaurantPhotoTableViewCell(indexPath: NSIndexPath) -> RestaurantPhotoTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            String(RestaurantPhotoTableViewCell),
            forIndexPath: indexPath
        ) as! RestaurantPhotoTableViewCell

        var photoUrls = [PhotoUrl]()
        if let restaurant = maybeRestaurant {
            photoUrls = restaurant.photoUrls
        }

        cell.delegate = self
        cell.configureCell(reloader, photoUrls: photoUrls, router: router)

        return cell
    }

    private func initSubtitleTableViewCellForComment(comment: PersistedComment) -> UITableViewCell {
        var maybeCell = tableView.dequeueReusableCellWithIdentifier(String(UITableViewCell))

        if (maybeCell == nil) {
            maybeCell = UITableViewCell(
                style: .Subtitle,
                reuseIdentifier: String(UITableViewCell)
            )
        }

        guard let cell = maybeCell else { return UITableViewCell() }

        let createdDateString = DateConverter.formattedDate(comment.createdDate)

        cell.backgroundColor = UIColor.greenColor()
        cell.selectionStyle = .None
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = comment.text
        cell.detailTextLabel?.text = String("\(comment.userName) - \(createdDateString)")

        return cell
    }
}

// MARK: - UITableViewDelegate
extension RestaurantDetailViewController: UITableViewDelegate {
    func tableView(
        tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return isCommentPostedByCurrentUser(indexPath)
    }

    func tableView(
        tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            guard
                let currentRestaurant = maybeRestaurant
            else {
                    return
            }
            let comment = currentRestaurant.comments[indexPath.row]
            maybeRestaurant!.comments.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.commentRepo.delete(comment.id)
        }
    }


    // MARK: - Private Methods
    private func isCommentPostedByCurrentUser(indexPath: NSIndexPath) -> Bool {
        guard
            indexPath.section == RestaurantDetailTableViewSections.CommentsSection.rawValue,
            let currentRestaurant = maybeRestaurant,
            let userId = currentUserId
            else {
                return false
        }
        return userId == currentRestaurant.comments[indexPath.row].userId
    }

    private func deleteCommentAtIndexPath(indexPath: NSIndexPath) {
        guard
            indexPath.section == 1 && maybeRestaurant != nil
        else {
            return
        }

        let comment = maybeRestaurant!.comments[indexPath.row]

        self.commentRepo.delete(comment.id)

        maybeRestaurant!.comments.removeAtIndex(indexPath.row)

        tableView.deleteRowsAtIndexPaths(
            [indexPath],
            withRowAnimation: .None
        )
    }
}

// MARK: - RestaurantDetailTableViewCellDelegate
extension RestaurantDetailViewController: RestaurantDetailTableViewCellDelegate {
    @objc func displayAddCommentScreen(sender: UIButton) {
        router.showNewCommentScreen(self.maybeRestaurant!.id)
    }

    @objc func didTapLikeButton(sender: UIButton) {
        maybeRestaurant = maybeRestaurant?.newRetaurantWithLikeToggled()

        likeRepo.setRestaurantLiked(restaurantId, liked: (maybeRestaurant?.liked)!)

        reloader.reload(tableView)
    }

    @objc func displayMapScreen(sender: UIButton) {
        router.showMapScreen(maybeRestaurant?.latitude ?? 0.0, longitude: maybeRestaurant?.longitude ?? 0.0)
    }
}

// MARK: - RestaurantPhotoTableViewCellDelegate
extension RestaurantDetailViewController: RestaurantPhotoTableViewCellDelegate {
    @objc func displayImageScreen(url: NSURL) {
        router.showImageScreen(url)
    }
}
