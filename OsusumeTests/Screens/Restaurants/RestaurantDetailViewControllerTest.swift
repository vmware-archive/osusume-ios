import XCTest
import Nimble

@testable import Osusume

class RestaurantDetailViewControllerTest: XCTestCase {
    let router = FakeRouter()
    let repo = FakeRestaurantRepo()
    let reloader = FakeReloader()

    var restaurantDetailVC: RestaurantDetailViewController!
    let today = NSDate()
    var tomorrow: NSDate {
        return NSDate(timeInterval: 60*60*24, sinceDate: today)
    }

    override func setUp() {
        restaurantDetailVC = RestaurantDetailViewController(
            router: router,
            reloader: reloader,
            repo: repo,
            restaurantId: 1
        )

        repo.createdRestaurant = Restaurant(
            id: 1,
            name: "My Restaurant",
            address: "Roppongi",
            cuisineType: "Sushi",
            offersEnglishMenu: true,
            walkInsOk: false,
            acceptsCreditCards: true,
            notes: "This place is great",
            author: "Danny",
            createdAt: NSDate(timeIntervalSince1970: 0),
            photoUrls: [NSURL(string: "my-awesome-url")!],
            comments: [
                PersistedComment(
                    id: 1,
                    text: "first comment",
                    createdDate: today,
                    restaurantId: 1,
                    userName: "Danny"
                ),
                PersistedComment(
                    id: 2,
                    text: "second comment",
                    createdDate: tomorrow,
                    restaurantId: 1,
                    userName: "Witta"
                )
            ]
        )
    }

    func test_onViewWillAppear_showsComments() {
        restaurantDetailVC.view.setNeedsLayout()
        restaurantDetailVC.viewWillAppear(false)

        let commentSectionIndex = 1
        expect(self.restaurantDetailVC.tableView.numberOfRowsInSection(commentSectionIndex)).to(equal(2))

        let firstCommentCell = restaurantDetailVC.tableView(
            restaurantDetailVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: commentSectionIndex)
        )

        expect(firstCommentCell.textLabel!.text).to(equal("first comment"))
        expect(firstCommentCell.detailTextLabel!.text).to(equal("Danny - \(DateConverter().formattedDate(today))"))

        let secondCommentCell = restaurantDetailVC.tableView(
            restaurantDetailVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: commentSectionIndex)
        )
        expect(secondCommentCell.textLabel!.text).to(equal("second comment"))
        expect(secondCommentCell.detailTextLabel!.text).to(equal("Witta - \(DateConverter().formattedDate(tomorrow))"))
    }

    func test_onViewWillAppear_reloadsTableViewData() {
        restaurantDetailVC.view.setNeedsLayout()
        restaurantDetailVC.viewWillAppear(false)

        expect(self.reloader.reload_wasCalled).to(equal(true))
    }

    func test_tappingTheEditButton_showsTheEditScreen() {
        restaurantDetailVC.view.setNeedsLayout()
        restaurantDetailVC.viewWillAppear(false)

        expect(self.restaurantDetailVC.navigationItem.rightBarButtonItem?.title).to(equal("Edit"))

        let updateButton = restaurantDetailVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(updateButton)

        expect(self.router.editRestaurantScreenIsShowing).to(equal(true))
    }

    func test_tappingTheAddCommentButton_showsTheNewCommentScreen() {
        restaurantDetailVC = RestaurantDetailViewController(
            router: router,
            reloader: DefaultReloader(),
            repo: repo,
            restaurantId: 1
        )

        restaurantDetailVC.view.setNeedsLayout()
        restaurantDetailVC.viewWillAppear(false)

        let indexOfRestaurantDetailCell = NSIndexPath(forRow: 0, inSection: 0)
        let restaurantDetailCell = restaurantDetailVC.tableView.cellForRowAtIndexPath(indexOfRestaurantDetailCell) as! RestaurantDetailTableViewCell

        restaurantDetailCell.addCommentButton.sendActionsForControlEvents(.TouchUpInside)

        expect(self.router.newCommentScreenIsShowing).to(equal(true))
        expect(self.router.showNewCommentScreen_args).to(equal(1))
    }
}
