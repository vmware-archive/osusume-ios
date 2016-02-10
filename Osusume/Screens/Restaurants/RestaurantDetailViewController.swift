import Foundation
import UIKit
import PureLayout
import BrightFutures

class RestaurantDetailViewController : UIViewController {
    unowned let router: Router
    let repo: RestaurantRepo
    let id: Int
    var restaurant: Restaurant? = nil

    //MARK: - Initializers

    init(router: Router, repo: RestaurantRepo, id: Int) {
        self.router = router
        self.repo = repo
        self.id = id

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantDetailViewController")
    }

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
    let authorLabel = UILabel()

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
        scrollViewContentView.addSubview(authorLabel)

        applyViewConstraints()

        repo.getOne(self.id)
            .onSuccess(ImmediateExecutionContext) { [unowned self] returnedRestaurant in
                self.restaurant = returnedRestaurant
                self.nameLabel.text = self.restaurant!.name
                self.addressLabel.text = self.restaurant!.address
                self.cuisineTypeLabel.text = self.restaurant!.cuisineType
                self.offersEnglishMenuLabel.text = self.restaurant!.offersEnglishMenu ? "Offers English menu" : "Does not offer English menu"
                self.walkInsOkLabel.text = self.restaurant!.walkInsOk ? "Walk-ins ok" : "Walk-ins not recommended"
                self.acceptsCreditCardsLabel.text = self.restaurant!.acceptsCreditCards ? "Accepts credit cards" : "Does not accept credit cards"
                self.notesLabel.text = self.restaurant!.notes
                self.authorLabel.text = "Added by \(self.restaurant!.author)"
        }

        let editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("didTapEditRestaurantButton:"))
        navigationItem.rightBarButtonItem = editButton
    }

    //MARK: - Actions
    func didTapEditRestaurantButton(sender: UIBarButtonItem) {
        if let currentRestaurant = self.restaurant {
            router.showEditRestaurantScreen(currentRestaurant)
        }
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

        authorLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
        authorLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: notesLabel)
    }
}