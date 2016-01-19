import Foundation
import UIKit
import PureLayout
import BrightFutures

class RestaurantDetailViewController : UIViewController {
    unowned let router: Router
    let repo: RestaurantRepo
    let id: Int
    var restaurant: Restaurant? = nil
    var didSetupConstraints = false


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
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let cuisineTypeLabel = UILabel()
    let offersEnglishMenuLabel = UILabel()
    let walkInsOkLabel = UILabel()
    let acceptsCreditCardsLabel = UILabel()


    //MARK: - View Lifecycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(nameLabel)
        view.addSubview(addressLabel)
        view.addSubview(cuisineTypeLabel)
        view.addSubview(offersEnglishMenuLabel)
        view.addSubview(walkInsOkLabel)
        view.addSubview(acceptsCreditCardsLabel)
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        repo.getOne(self.id)
            .onSuccess(ImmediateExecutionContext) { [unowned self] returnedRestaurant in
                self.restaurant = returnedRestaurant
                self.nameLabel.text = self.restaurant!.name
                self.addressLabel.text = self.restaurant!.address
                self.cuisineTypeLabel.text = self.restaurant!.cuisineType
                self.offersEnglishMenuLabel.text = self.restaurant!.offersEnglishMenu ? "Offers English menu" : "Does not offer English menu"
                self.walkInsOkLabel.text = self.restaurant!.walkInsOk ? "Walk-ins ok" : "Walk-ins not recommended"
                self.acceptsCreditCardsLabel.text = self.restaurant!.acceptsCreditCards ? "Accepts credit cards" : "Does not accept credit cards"
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
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            nameLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
            nameLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
            nameLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)

            addressLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: nameLabel)
            addressLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: nameLabel)
            addressLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLabel)

            cuisineTypeLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: addressLabel)
            cuisineTypeLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: addressLabel)
            cuisineTypeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: addressLabel)

            offersEnglishMenuLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: cuisineTypeLabel)
            offersEnglishMenuLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: cuisineTypeLabel)
            offersEnglishMenuLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: cuisineTypeLabel)

            walkInsOkLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: offersEnglishMenuLabel)
            walkInsOkLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: offersEnglishMenuLabel)
            walkInsOkLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: offersEnglishMenuLabel)

            acceptsCreditCardsLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: walkInsOkLabel)
            acceptsCreditCardsLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: walkInsOkLabel)
            acceptsCreditCardsLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: walkInsOkLabel)

            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}