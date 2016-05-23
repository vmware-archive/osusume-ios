import BrightFutures
import XCTest
import Nimble

@testable import Osusume

class RestaurantDetailViewControllerTest: XCTestCase {
    let fakeRouter = FakeRouter()
    let fakeRestaurantRepo = FakeRestaurantRepo()
    let fakeSessionRepo = FakeSessionRepo()
    let fakeLikeRepo = FakeLikeRepo()
    let fakeCommentRepo = FakeCommentRepo()
    let restaurantRepoPromise = Promise<Restaurant, RepoError>()
    var restaurant: Restaurant!
    var restaurantDetailVC: RestaurantDetailViewController!

    let commentSectionIndex = 1
    let today = NSDate()
    var tomorrow: NSDate {
        return NSDate(timeInterval: 60*60*24, sinceDate: today)
    }
    let authenticatedDanny = AuthenticatedUser(id: 100, email: "danny-email", token: "token")

    override func setUp() {
        restaurant = RestaurantFixtures.newRestaurant(
            comments: [
                PersistedComment(
                    id: 1,
                    text: "first comment",
                    createdDate: today,
                    restaurantId: 1,
                    userId: 100,
                    userName: "Danny"
                ),
                PersistedComment(
                    id: 2,
                    text: "second comment",
                    createdDate: today,
                    restaurantId: 1,
                    userId: 2,
                    userName: "Jeana"
                )
            ]
        )
    }

    // MARK: - Initialization
    func test_init_retrievesCurrentUserId() {
        setupViewControllerWithReloader()


        expect(self.restaurantDetailVC.currentUserId!).to(equal(authenticatedDanny.id))
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_setsTitle() {
        setupViewControllerWithReloader()
        expect(self.restaurantDetailVC.title).to(equal("Restaurant Details"))
    }

    func test_onViewWillAppear_showsComments() {
        setupViewControllerWithReloader()


        let actualRowCount = self.restaurantDetailVC.tableView
            .numberOfRowsInSection(commentSectionIndex)
        expect(actualRowCount).to(equal(2))

        let firstCommentCell = restaurantDetailVC.tableView(
            restaurantDetailVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: commentSectionIndex)
        )
        let secondCommentCell = restaurantDetailVC.tableView(
            restaurantDetailVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: commentSectionIndex)
        )
        expect(firstCommentCell.textLabel!.text).to(equal("first comment"))
        expect(firstCommentCell.detailTextLabel!.text)
            .to(equal("Danny - \(DateConverter.formattedDate(today))"))
        expect(secondCommentCell.textLabel!.text).to(equal("second comment"))
        expect(secondCommentCell.detailTextLabel!.text)
            .to(equal("Jeana - \(DateConverter.formattedDate(today))"))
    }

    func test_onViewWillAppear_reloadsTableViewData() {
        let fakeReloader = FakeReloader()
        setupViewControllerWithReloader(fakeReloader)


        expect(fakeReloader.reload_wasCalled).to(equal(true))
    }

    func test_viewDidLoad_registersRestaurantDetailCellClass() {
        setupViewControllerWithReloader()
        let cell: UITableViewCell? = restaurantDetailVC.tableView.dequeueReusableCellWithIdentifier(String(RestaurantDetailTableViewCell))


        expect(cell).toNot(beNil())
    }

    func test_tappingTheEditButton_showsTheEditScreen() {
        setupViewControllerWithReloader()

        expect(self.restaurantDetailVC.navigationItem.rightBarButtonItem?.title)
            .to(equal("Edit"))


        let updateButton = restaurantDetailVC.navigationItem.rightBarButtonItem!
        tapNavBarButton(updateButton)


        expect(self.fakeRouter.editRestaurantScreenIsShowing).to(equal(true))
    }

    func test_tappingTheAddCommentButton_showsTheNewCommentScreen() {
        setupViewControllerWithReloader()


        let restaurantDetailCell = getRestaurantDetailCell()
        tapButton(restaurantDetailCell.addCommentButton)


        expect(self.fakeRouter.newCommentScreenIsShowing).to(equal(true))
        expect(self.fakeRouter.showNewCommentScreen_args).to(equal(1))
    }

    func test_tappingTheLikeButton_callsTheController() {
        setupViewControllerWithReloader()


        let restaurantDetailCell = getRestaurantDetailCell()
        tapButton(restaurantDetailCell.likeButton)


        expect(self.fakeLikeRepo.like_wasCalled).to(beTrue())
        expect(self.fakeLikeRepo.like_arg).to(equal(restaurant.id))
    }

    func test_tappingTheLikeButton_togglesTheColorOfTheButton() {
        setupViewControllerWithReloader()

        let promise = Promise<Like, LikeRepoError>()
        fakeLikeRepo.like_returnValue = promise.future


        let restaurantDetailCell = getRestaurantDetailCell()
        tapButton(restaurantDetailCell.likeButton)


        promise.success(Like())

        expect(restaurantDetailCell.likeButton.backgroundColor)
            .toEventually(equal(UIColor.redColor()))
        expect(restaurantDetailCell.likeButton.titleColorForState(.Normal))
            .toEventually(equal(UIColor.blueColor()))
    }

    // MARK: - UITableViewDelegate
    func test_canEdit_commentsPostedByCurrentUser() {
        setupViewControllerWithReloader()


        let canEditOwnComment = restaurantDetailVC.tableView(
            restaurantDetailVC.tableView,
            canEditRowAtIndexPath: NSIndexPath(forRow: 0, inSection: commentSectionIndex)
        )


        expect(canEditOwnComment).to(beTrue())
    }

    func test_cannotEdit_commentsPostedByADifferentUser() {
        setupViewControllerWithReloader()


        let canEditOwnComment = restaurantDetailVC.tableView(
            restaurantDetailVC.tableView,
            canEditRowAtIndexPath: NSIndexPath(forRow: 1, inSection: commentSectionIndex)
        )


        expect(canEditOwnComment).to(beFalse())
    }

    func test_commitingCommentDelete_deletesCommentFromRestaurantCommentsArray() {
        setupViewControllerWithReloader()


        restaurantDetailVC.tableView(
            restaurantDetailVC.tableView,
            commitEditingStyle : UITableViewCellEditingStyle.Delete,
            forRowAtIndexPath : NSIndexPath(forRow: 0, inSection: commentSectionIndex))



        expect(self.restaurantDetailVC.restaurant!.comments.count).to(equal(1))
    }

    func test_commitingCommentDelete_deletesCommentWithRepo() {
        let currentUsersCommentId = 1
        setupViewControllerWithReloader()


        restaurantDetailVC.tableView(
            restaurantDetailVC.tableView,
            commitEditingStyle: .Delete,
            forRowAtIndexPath: NSIndexPath(forRow: 0, inSection: commentSectionIndex)
        )


        expect(self.fakeCommentRepo.delete_arg).to(equal(currentUsersCommentId))
    }

    // MARK: - Private Methods
    private func setupViewControllerWithReloader(reloader: Reloader = DefaultReloader()) {
        fakeRestaurantRepo.getOne_returnValue = restaurantRepoPromise.future
        fakeSessionRepo.getAuthenticatedUser_returnValue = authenticatedDanny

        restaurantDetailVC = RestaurantDetailViewController(
            router: fakeRouter,
            reloader: reloader,
            restaurantRepo: fakeRestaurantRepo,
            likeRepo: fakeLikeRepo,
            sessionRepo: fakeSessionRepo,
            commentRepo: fakeCommentRepo,
            restaurantId: restaurant.id
        )

        restaurantDetailVC.view.setNeedsLayout()
        restaurantDetailVC.viewWillAppear(false)
        restaurantRepoPromise.success(restaurant)
        NSRunLoop.osu_advance()
    }

    private func getRestaurantDetailCell() -> RestaurantDetailTableViewCell {
        let indexOfRestaurantDetailCell = NSIndexPath(forRow: 0, inSection: 0)
        return restaurantDetailVC.tableView
            .cellForRowAtIndexPath(indexOfRestaurantDetailCell) as! RestaurantDetailTableViewCell
    }
}
