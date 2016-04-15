import BrightFutures
import XCTest
import Nimble

@testable import Osusume

class RestaurantDetailViewControllerTest: XCTestCase {
    let fakeRouter = FakeRouter()
    let fakeRestaurantRepo = FakeRestaurantRepo()
    let fakeLikeRepo = FakeLikeRepo()
    let fakeReloader = FakeReloader()
    let restaurantId = 1

    var restaurantDetailVC: RestaurantDetailViewController!
    let today = NSDate()
    var tomorrow: NSDate {
        return NSDate(timeInterval: 60*60*24, sinceDate: today)
    }

    override func setUp() {
        restaurantDetailVC = RestaurantDetailViewController(
            router: fakeRouter,
            reloader: fakeReloader,
            restaurantRepo: fakeRestaurantRepo,
            likeRepo: fakeLikeRepo,
            restaurantId: restaurantId
        )

        fakeRestaurantRepo.createdRestaurant = Restaurant(
            id: 1,
            name: "My Restaurant",
            address: "Roppongi",
            cuisineType: "Sushi",
            cuisine: Cuisine(id: 1, name: "Pizza"),
            offersEnglishMenu: true,
            walkInsOk: false,
            acceptsCreditCards: true,
            notes: "This place is great",
            author: "Danny",
            liked: false,
            numberOfLikes: 0,
            createdAt: NSDate(timeIntervalSince1970: 0),
            photoUrls: [NSURL(string: "my-awesome-url")!],
            comments: [
                PersistedComment(
                    id: 1,
                    text: "first comment",
                    createdDate: today,
                    restaurantId: 1,
                    userName: "Danny"
                )
            ]
        )
    }

    func test_onViewWillAppear_showsComments() {
        restaurantDetailVC.view.setNeedsLayout()
        restaurantDetailVC.viewWillAppear(false)

        let commentSectionIndex = 1
        let actualRowCount = self.restaurantDetailVC.tableView
            .numberOfRowsInSection(commentSectionIndex)

        expect(actualRowCount).to(equal(1))

        let firstCommentCell = restaurantDetailVC.tableView(
            restaurantDetailVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: commentSectionIndex)
        )

        expect(firstCommentCell.textLabel!.text).to(equal("first comment"))
        expect(firstCommentCell.detailTextLabel!.text)
            .to(equal("Danny - \(DateConverter().formattedDate(today))"))

    }

    func test_onViewWillAppear_reloadsTableViewData() {
        restaurantDetailVC.view.setNeedsLayout()
        restaurantDetailVC.viewWillAppear(false)

        expect(self.fakeReloader.reload_wasCalled).to(equal(true))
    }

    func test_tappingTheEditButton_showsTheEditScreen() {
        restaurantDetailVC.view.setNeedsLayout()
        restaurantDetailVC.viewWillAppear(false)

        expect(self.restaurantDetailVC.navigationItem.rightBarButtonItem?.title)
            .to(equal("Edit"))

        let updateButton = restaurantDetailVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(updateButton)

        expect(self.fakeRouter.editRestaurantScreenIsShowing).to(equal(true))
    }

    func test_tappingTheAddCommentButton_showsTheNewCommentScreen() {
        restaurantDetailVC = RestaurantDetailViewController(
            router: fakeRouter,
            reloader: DefaultReloader(),
            restaurantRepo: fakeRestaurantRepo,
            likeRepo: FakeLikeRepo(),
            restaurantId: 1
        )

        restaurantDetailVC.view.setNeedsLayout()
        restaurantDetailVC.viewWillAppear(false)

        let indexOfRestaurantDetailCell = NSIndexPath(forRow: 0, inSection: 0)
        let restaurantDetailCell = restaurantDetailVC.tableView
            .cellForRowAtIndexPath(indexOfRestaurantDetailCell) as! RestaurantDetailTableViewCell


        restaurantDetailCell.addCommentButton.sendActionsForControlEvents(.TouchUpInside)


        expect(self.fakeRouter.newCommentScreenIsShowing).to(equal(true))
        expect(self.fakeRouter.showNewCommentScreen_args).to(equal(1))
    }

    func test_tappingTheLikeButton_callsTheController() {
        restaurantDetailVC = RestaurantDetailViewController(
            router: fakeRouter,
            reloader: DefaultReloader(),
            restaurantRepo: fakeRestaurantRepo,
            likeRepo: fakeLikeRepo,
            restaurantId: 1
        )

        restaurantDetailVC.view.setNeedsLayout()
        restaurantDetailVC.viewWillAppear(false)

        let indexOfRestaurantDetailCell = NSIndexPath(forRow: 0, inSection: 0)
        let restaurantDetailCell = restaurantDetailVC.tableView
            .cellForRowAtIndexPath(indexOfRestaurantDetailCell) as! RestaurantDetailTableViewCell


        restaurantDetailCell.likeButton.sendActionsForControlEvents(.TouchUpInside)


        expect(self.fakeLikeRepo.like_wasCalled).to(beTrue())
        expect(self.fakeLikeRepo.like_arg).to(equal(restaurantId))
    }

    func test_tappingTheLikeButton_togglesTheColorOfTheButton() {
        let likeButton = UIButton()
        let promise = Promise<Like, LikeRepoError>()
        fakeLikeRepo.like_returnValue = promise.future

        restaurantDetailVC.didTapLikeButton(likeButton)

        promise.success(Like())

        expect(likeButton.backgroundColor).toEventually(equal(UIColor.redColor()))
        expect(likeButton.titleColorForState(.Normal)).toEventually(equal(UIColor.blueColor()))
    }
}
