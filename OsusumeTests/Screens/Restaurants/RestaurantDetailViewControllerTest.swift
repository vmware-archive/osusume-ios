import BrightFutures
import XCTest
import Nimble

@testable import Osusume

class RestaurantDetailViewControllerTest: XCTestCase {
    let fakeRouter = FakeRouter()
    let fakeRestaurantRepo = FakeRestaurantRepo()
    let fakeLikeRepo = FakeLikeRepo()
    let restaurantRepoPromise = Promise<Restaurant, RepoError>()
    var restaurant: Restaurant!

    var restaurantDetailVC: RestaurantDetailViewController!
    let today = NSDate()
    var tomorrow: NSDate {
        return NSDate(timeInterval: 60*60*24, sinceDate: today)
    }

    override func setUp() {
        restaurant = RestaurantFixtures.newRestaurant(
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
        setupViewControllerWithReloader()


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
            .to(equal("Danny - \(DateConverter.formattedDate(today))"))
    }

    func test_onViewWillAppear_reloadsTableViewData() {
        let fakeReloader = FakeReloader()
        setupViewControllerWithReloader(fakeReloader)


        expect(fakeReloader.reload_wasCalled).to(equal(true))
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

    // MARK: - Private Methods
    private func setupViewControllerWithReloader(reloader: Reloader = DefaultReloader()) {
        fakeRestaurantRepo.getOne_returnValue = restaurantRepoPromise.future

        restaurantDetailVC = RestaurantDetailViewController(
            router: fakeRouter,
            reloader: reloader,
            restaurantRepo: fakeRestaurantRepo,
            likeRepo: fakeLikeRepo,
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
