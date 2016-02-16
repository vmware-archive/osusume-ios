import Foundation
import UIKit
import PureLayout
import BrightFutures

class RestaurantDetailViewController : UIViewController {
    unowned let router: Router
    let repo: RestaurantRepo
    let sessionRepo: SessionRepo

    let restaurantId: Int
    var restaurant: Restaurant? = nil

    //MARK: - View Elements
    let scrollView  = UIScrollView.newAutoLayoutView()
    let scrollViewContentView = UIView.newAutoLayoutView()

    let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let cuisineTypeLabel = UILabel()
    let offersEnglishMenuLabel = UILabel()
    let walkInsOkLabel = UILabel()
    let acceptsCreditCardsLabel = UILabel()
    let notesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    let creationInfoLabel = UILabel()
    let addCommentButton = UIButton.newAutoLayoutView()

    //MARK: - Initializers

    init(
        router: Router,
        repo: RestaurantRepo,
        restaurantId: Int,
        sessionRepo: SessionRepo)
    {
        self.router = router
        self.repo = repo
        self.restaurantId = restaurantId
        self.sessionRepo = sessionRepo

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantDetailViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(scrollViewContentView)
        scrollViewContentView.addSubview(headerImageView)
        scrollViewContentView.addSubview(nameLabel)
        scrollViewContentView.addSubview(addressLabel)
        scrollViewContentView.addSubview(cuisineTypeLabel)
        scrollViewContentView.addSubview(offersEnglishMenuLabel)
        scrollViewContentView.addSubview(walkInsOkLabel)
        scrollViewContentView.addSubview(acceptsCreditCardsLabel)
        scrollViewContentView.addSubview(notesLabel)
        scrollViewContentView.addSubview(creationInfoLabel)
        scrollViewContentView.addSubview(addCommentButton)

        applyViewConstraints()

        repo.getOne(self.restaurantId)
            .onSuccess(ImmediateExecutionContext) { [unowned self] returnedRestaurant in
                self.restaurant = returnedRestaurant

                let setAccessibilityTypeCompletionHandler: SDWebImageCompletionBlock = {
                    (image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in

                    if error == nil {
                        self.headerImageView.accessibilityLabel = "Picture of \(self.restaurant!.name)"
                    }
                }

                self.headerImageView.sd_setImageWithURL(self.restaurant!.photoUrl, completed: setAccessibilityTypeCompletionHandler)

                let restaurantDetailPresenter = RestaurantDetailPresenter(restaurant: returnedRestaurant)
                self.nameLabel.text = restaurantDetailPresenter.name
                self.addressLabel.text = restaurantDetailPresenter.address
                self.cuisineTypeLabel.text = restaurantDetailPresenter.cuisineType
                self.offersEnglishMenuLabel.text = restaurantDetailPresenter.offersEnglishMenu
                self.walkInsOkLabel.text = restaurantDetailPresenter.walkInsOk
                self.acceptsCreditCardsLabel.text = restaurantDetailPresenter.creditCardsOk
                self.notesLabel.text = restaurantDetailPresenter.notes
                self.creationInfoLabel.text = restaurantDetailPresenter.creationInfo
        }

        let editButton = UIBarButtonItem(
            title: "Edit",
            style: .Plain,
            target: self,
            action: Selector("didTapEditRestaurantButton:")
        )
        navigationItem.rightBarButtonItem = editButton

        addCommentButton.addTarget(
            self,
            action: "didTapAddNewCommentButton",
            forControlEvents: .TouchUpInside
        )
        addCommentButton.setTitle("Add comment", forState: .Normal)
        addCommentButton.backgroundColor = UIColor.grayColor()
    }

    //MARK: - Actions
    func didTapEditRestaurantButton(sender: UIBarButtonItem) {
        if let currentRestaurant = self.restaurant {
            router.showEditRestaurantScreen(currentRestaurant)
        }
    }

    func didTapAddNewCommentButton() {
        router.showNewCommentScreen(self.restaurant!.id)
    }

    //MARK: - Constraints
    func applyViewConstraints() {
        scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)

        scrollViewContentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        scrollViewContentView.autoMatchDimension(.Height, toDimension: .Height, ofView: view)
        scrollViewContentView.autoMatchDimension(.Width, toDimension: .Width, ofView: view)

        headerImageView.autoPinEdge(.Top, toEdge: .Top, ofView: scrollViewContentView)
        headerImageView.autoSetDimension(.Height, toSize: 150.0)
        headerImageView.autoAlignAxis(.Vertical, toSameAxisOfView: view)

        nameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: headerImageView)
        nameLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)

        addressLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        addressLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel)

        cuisineTypeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        cuisineTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressLabel)

        offersEnglishMenuLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        offersEnglishMenuLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeLabel)

        walkInsOkLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        walkInsOkLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: offersEnglishMenuLabel)

        acceptsCreditCardsLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        acceptsCreditCardsLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: walkInsOkLabel)

        notesLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        notesLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        notesLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: acceptsCreditCardsLabel)

        creationInfoLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        creationInfoLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: notesLabel)

        addCommentButton.autoPinEdge(.Leading, toEdge: .Leading, ofView: creationInfoLabel)
        addCommentButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: creationInfoLabel)

    }
}