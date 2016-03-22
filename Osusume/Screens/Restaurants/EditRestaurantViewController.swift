import Foundation
import UIKit
import PureLayout
import BrightFutures

class EditRestaurantViewController: UIViewController {

    unowned let router: Router
    let repo: RestaurantRepo

    let restaurant: Restaurant
    let id: Int

    //MARK: - Initializers
    init(
        router: Router,
        repo: RestaurantRepo,
        restaurant: Restaurant)
    {
        self.router = router
        self.repo = repo
        self.restaurant = restaurant
        self.id = restaurant.id

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported for RestaurantDetailViewController")
    }

    //MARK: - View Elements
    let scrollView = UIScrollView.newAutoLayoutView()
    let contentInScrollView = UIView.newAutoLayoutView()
    let formViewContainer = UIView.newAutoLayoutView()
    var formView: EditRestaurantFormView!

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.addSubview(contentInScrollView)
        contentInScrollView.addSubview(formViewContainer)

        formView = EditRestaurantFormView(restaurant: restaurant)
        formViewContainer.addSubview(formView)

        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)

        contentInScrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        contentInScrollView.autoMatchDimension(.Height, toDimension: .Height, ofView: view)
        contentInScrollView.autoMatchDimension(.Width, toDimension: .Width, ofView: view)

        formViewContainer.autoPinEdgeToSuperviewEdge(.Top)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)

        formView.autoPinEdgesToSuperviewEdges()

        let updateButton = UIBarButtonItem(title: "Update", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("didTapUpdateButton:"))
        navigationItem.rightBarButtonItem = updateButton
    }

    //MARK: - Actions
    func didTapUpdateButton(sender: UIBarButtonItem?) {
        let params: [String: AnyObject] = [
            "name": formView.getNameText()!,
            "address": formView.getAddressText()!,
            "cuisine_type": formView.getCuisineTypeText()!,
            "cuisine": formView.cuisine,
            "offers_english_menu": formView.getOffersEnglishMenuState()!,
            "walk_ins_ok": formView.getWalkInsOkState()!,
            "accepts_credit_cards": formView.getAcceptsCreditCardsState()!,
            "notes": formView.getNotesText()!
        ]
        repo.update(self.id, params: params)
            .onSuccess(ImmediateExecutionContext) { [unowned self] _ in
                self.router.showRestaurantListScreen()
        }
    }
}