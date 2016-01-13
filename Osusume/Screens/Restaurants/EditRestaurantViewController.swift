import Foundation
import UIKit
import PureLayout
import BrightFutures

class EditRestaurantViewController: UIViewController {

    unowned let router: Router
    let repo: RestaurantRepo
    var restaurant: Restaurant? = nil
    var didSetupConstraints = false
    var formView: RestaurantFormView!
    var id: Int!

    //MARK: - Initializers
    init(router: Router, repo: RestaurantRepo, restaurant: Restaurant) {
        self.router = router
        self.repo = repo
        self.restaurant = restaurant
        self.id = restaurant.id
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantDetailViewController")
    }

    //MARK: - View Lifecycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.grayColor()
        formView = RestaurantFormView(restaurant: self.restaurant)
        view.addSubview(self.formView)
        view.addSubview(updateButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.addTarget(self, action: Selector("updateButtonTapped:"), forControlEvents: .TouchUpInside)
    }


    //MARK: - Actions
    func updateButtonTapped(sender: UIButton) {
        if dataHasChanged(restaurant!) {
            let params: [String: AnyObject] = [
                "name": formView.getNameText()!,
                "address": formView.getAddressText()!,
                "cuisine_type": formView.getCuisineTypeText()!,
                "offers_english_menu": formView.getOffersEnglishMenuState()!,
                "walk_ins_ok": formView.getWalkInsOkState()!,
                "accepts_credit_cards": formView.getAcceptsCreditCardsState()!
            ]
            repo.update(self.id, params: params)
                .onSuccess(ImmediateExecutionContext) { [unowned self] _ in
                    self.router.showRestaurantListScreen()
            }
        }
    }

    func dataHasChanged(restaurant: Restaurant) -> Bool {
        return true
    }

    // MARK: - Constraints
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            formView.autoPinToTopLayoutGuideOfViewController(self, withInset: 0.0)
            formView.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)
            formView.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
            formView.autoSetDimension(.Height, toSize: 300.0)

            updateButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: formView)
            updateButton.autoAlignAxis(.Vertical, toSameAxisOfView: view)

            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    //MARK: - View Elements
    let updateButton : UIButton = {
        let button = UIButton()
        button.setTitle("Update", forState: .Normal)
        return button
    }()
}