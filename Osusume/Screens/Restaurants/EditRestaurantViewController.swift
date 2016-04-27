import Foundation
import UIKit
import PureLayout
import BrightFutures

class EditRestaurantViewController: UIViewController {
    // MARK: - Properties
    private unowned let router: Router
    private let repo: RestaurantRepo
    private let restaurant: Restaurant
    private let id: Int

    // MARK: - View Elements
    let scrollView: UIScrollView
    let contentInScrollView: UIView
    let formViewContainer: UIView
    let formView: EditRestaurantFormView

    // MARK: - Initializers
    init(
        router: Router,
        repo: RestaurantRepo,
        restaurant: Restaurant)
    {
        self.router = router
        self.repo = repo
        self.restaurant = restaurant
        self.id = restaurant.id

        scrollView = UIScrollView.newAutoLayoutView()
        contentInScrollView = UIView.newAutoLayoutView()
        formViewContainer = UIView.newAutoLayoutView()
        formView = EditRestaurantFormView(restaurant: restaurant)

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

    // MARK: - View Setup
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Update",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: #selector(EditRestaurantViewController.didTapUpdateButton(_:))
        )
    }

    private func addSubviews() {
        formViewContainer.addSubview(formView)
        contentInScrollView.addSubview(formViewContainer)
        scrollView.addSubview(contentInScrollView)
        view.addSubview(scrollView)
    }

    private func configureSubviews() {
        scrollView.backgroundColor = UIColor.whiteColor()
    }

    private func addConstraints() {
        scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)

        contentInScrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        contentInScrollView.autoMatchDimension(.Height, toDimension: .Height, ofView: view)
        contentInScrollView.autoMatchDimension(.Width, toDimension: .Width, ofView: view)

        formViewContainer.autoPinEdgeToSuperviewEdge(.Top)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 10.0)
        formViewContainer.autoPinEdgeToSuperviewEdge(.Leading, withInset: 10.0)

        formView.autoPinEdgesToSuperviewEdges()
    }

    // MARK: - Actions
    @objc private func didTapUpdateButton(sender: UIBarButtonItem?) {
        let params: [String: AnyObject] = [
            "name": formView.getNameText()!,
            "address": formView.getAddressText()!,
            "cuisine_type": restaurant.cuisine.name,
            "cuisine_id": restaurant.cuisine.id,
            "offers_english_menu": formView.getOffersEnglishMenuState()!,
            "walk_ins_ok": formView.getWalkInsOkState()!,
            "accepts_credit_cards": formView.getAcceptsCreditCardsState()!,
            "notes": formView.getNotesText()!
        ]
        repo.update(self.id, params: params)
            .onSuccess(ImmediateExecutionContext) { [unowned self] _ in
                dispatch_async(dispatch_get_main_queue()) {
                    self.router.showRestaurantListScreen()
                }
        }
    }
}
