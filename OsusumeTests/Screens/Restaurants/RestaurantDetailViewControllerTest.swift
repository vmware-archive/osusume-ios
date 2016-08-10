import BrightFutures
import XCTest
import Nimble

@testable import Osusume

class RestaurantDetailViewControllerTest: XCTestCase {
    let fakeRouter = FakeRouter()
    let fakeReloader = FakeReloader()
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
    let authenticatedDanny = AuthenticatedUser(
        id: 100,
        email: "danny-email",
        token: "token",
        name: "Danny"
    )

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

    func test_onViewWillAppear_showsPhotoCollectionViewCellWhenThereArePhotos() {
        restaurant = RestaurantFixtures.newRestaurant(
            photoUrls: [PhotoUrl(id: 1, url: NSURL(string: "photo-url")!)]
        )

        setupViewControllerWithReloader()


        let numRowsInSectionZero = self.restaurantDetailVC.tableView.numberOfRowsInSection(0)
        let photoCollectionViewCell = self.restaurantDetailVC.tableView(
            self.restaurantDetailVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )
        let restaurantDetailTableViewCell = self.restaurantDetailVC.tableView(
            self.restaurantDetailVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)
        )

        expect(numRowsInSectionZero).to(equal(2))
        expect(photoCollectionViewCell).to(beAKindOf(RestaurantPhotoTableViewCell))
        expect(restaurantDetailTableViewCell).to(beAKindOf(RestaurantDetailTableViewCell))
    }

    func test_onViewWillAppear_hidesPhotoCollectionViewCellWhenThereAreNoPhotos() {
        setupViewControllerWithReloader()

        let numRowsInSectionZero = self.restaurantDetailVC.tableView.numberOfRowsInSection(0)
        let restaurantDetailTableViewCell = self.restaurantDetailVC.tableView(
            self.restaurantDetailVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )

        expect(numRowsInSectionZero).to(equal(1))
        expect(restaurantDetailTableViewCell).to(beAKindOf(RestaurantDetailTableViewCell))
    }

    func test_onViewWillAppear_showsCommentsWithMultipleLines() {
        setupViewControllerWithReloader()

        let firstCommentCell = restaurantDetailVC.tableView(
            restaurantDetailVC.tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: commentSectionIndex)
        )

        expect(firstCommentCell.textLabel?.numberOfLines).to(equal(0))
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

    func test_viewDidLoad_registersRestaurantPhotoTableViewCell() {
        setupViewControllerWithReloader()
        let cell: UITableViewCell? = restaurantDetailVC.tableView.dequeueReusableCellWithIdentifier(String(RestaurantPhotoTableViewCell))

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

    func test_showingThePhotoTableViewCell_showsPhotosInCollectionView() {
        let photoUrl = PhotoUrl(id: 1, url: NSURL(string: "photo-url")!)
        restaurant = RestaurantFixtures.newRestaurant(
            photoUrls: [photoUrl]
        )

        setupViewControllerWithReloader()

        let photoCell = getRestaurantPhotoCell()
        photoCell.imageCollectionView.dataSource
                as! PhotoUrlsCollectionViewDataSource

        expect(photoCell.dataSourcePhotoUrls.first)
            .to(equal(photoUrl))
    }

    // MARK: - Like Button
    func test_tappingTheLikeButtonToLike_callsTheLikeRepo() {
        setupViewControllerWithReloader()


        let restaurantDetailCell = getRestaurantDetailCell()
        tapButton(restaurantDetailCell.likeButton)


        expect(self.fakeLikeRepo.setRestaurantLiked_wasCalled)
            .to(beTrue())
        expect(self.fakeLikeRepo.setRestaurantLiked_args.restaurantId)
            .to(equal(restaurant.id))
        expect(self.fakeLikeRepo.setRestaurantLiked_args.liked)
            .to(beTrue())
    }

    func test_tappingTheLikeButtonToLike_togglesTheColorOfTheButton() {
        setupViewControllerWithReloader()


        let restaurantDetailCell = getRestaurantDetailCell()
        tapButton(restaurantDetailCell.likeButton)
        let updatedRestaurantDetailCell = getRestaurantDetailCell()


        expect(updatedRestaurantDetailCell.likeButton.backgroundColor)
            .to(equal(UIColor.redColor()))
        expect(updatedRestaurantDetailCell.likeButton.titleColorForState(.Normal))
            .to(equal(UIColor.blueColor()))
    }

    func test_tappingTheLikeButtonToUnlike_togglesTheColorOfTheButton() {
        restaurant = RestaurantFixtures.newRestaurant(
            liked: true,
            numberOfLikes: 1
        )
        setupViewControllerWithReloader()


        let restaurantDetailCell = getRestaurantDetailCell()
        tapButton(restaurantDetailCell.likeButton)
        let updatedRestaurantDetailCell = getRestaurantDetailCell()


        expect(updatedRestaurantDetailCell.likeButton.backgroundColor)
            .to(equal(UIColor.blueColor()))
        expect(updatedRestaurantDetailCell.likeButton.titleColorForState(.Normal))
            .to(equal(UIColor.redColor()))
    }

    func test_tappingTheLikeButton_reloadsTableView() {
        let fakeReloader = FakeReloader()
        setupViewControllerWithReloader(fakeReloader)


        restaurantDetailVC.tableView.reloadData()
        let restaurantDetailCell = getRestaurantDetailCell()
        tapButton(restaurantDetailCell.likeButton)


        expect(fakeReloader.reload_calledNumberOfTimes).to(equal(2))
    }

    func test_tappingTheLikeButtonToLike_increasesNumberOfLikes() {
        setupViewControllerWithReloader()


        let restaurantDetailCell = getRestaurantDetailCell()
        tapButton(restaurantDetailCell.likeButton)
        let updatedRestaurantDetailCell = getRestaurantDetailCell()


        expect(updatedRestaurantDetailCell.numberOfLikesLabel.text).to(equal("1 person liked"))
    }

    func test_tappingTheLikeButtonToUnlike_decreasesNumberOfLikes() {
        restaurant = RestaurantFixtures.newRestaurant(
            liked: true,
            numberOfLikes: 1
        )
        setupViewControllerWithReloader()


        let restaurantDetailCell = getRestaurantDetailCell()
        tapButton(restaurantDetailCell.likeButton)
        let updatedRestaurantDetailCell = getRestaurantDetailCell()


        expect(updatedRestaurantDetailCell.numberOfLikesLabel.text).to(equal("0 people liked"))
    }

    // MARK: - RestaurantDetailTableViewCellDelegate
    func test_detailTableViewCell_hasViewControllerAsDelegate() {
        setupViewControllerWithReloader()
        let restaurantDetailCell = getRestaurantDetailCell()
        expect(restaurantDetailCell.delegate === self.restaurantDetailVC).to(beTrue())
    }

    func test_callingTheDisplayMapsScreenMethod_displaysTheMapScreen() {
        setupViewControllerWithReloader()


        restaurantDetailVC.displayMapScreen(UIButton())


        expect(self.fakeRouter.mapScreenIsShowing).to(beTrue())
    }

    // MARK: - RestaurantPhotoTableViewCellDelegate
    func test_photoTableViewCell_hasViewControllerAsDelegate() {
        restaurant = RestaurantFixtures.newRestaurant(
            photoUrls: [PhotoUrl(id: 1, url: NSURL(string: "photo-url")!)]
        )
        setupViewControllerWithReloader()

        let restaurantPhotoCell = getRestaurantPhotoCell()
        expect(restaurantPhotoCell.delegate === self.restaurantDetailVC).to(beTrue())
    }

    func test_callingTheShowImageDelegateMethod_showsTheFullScreenImageScreen() {
        setupViewControllerWithReloader()
        let url = NSURL(string: "url")!


        restaurantDetailVC.displayImageScreen(url)


        expect(self.fakeRouter.imageScreenIsShowing).to(beTrue())
        expect(self.fakeRouter.showImageScreen_args).to(equal(url))
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



        expect(self.restaurantDetailVC.maybeRestaurant!.comments.count).to(equal(1))
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
        waitForFutureToComplete(restaurantRepoPromise.future)
    }

    private func getRestaurantDetailCell() -> RestaurantDetailTableViewCell {
        let indexOfRestaurantDetailCell = NSIndexPath(forRow: 0, inSection: 0)
        return restaurantDetailVC.tableView
            .cellForRowAtIndexPath(indexOfRestaurantDetailCell) as! RestaurantDetailTableViewCell
    }

    private func getRestaurantPhotoCell() -> RestaurantPhotoTableViewCell {
        let indexOfPhotoCell = NSIndexPath(forRow: 0, inSection: 0)
        return restaurantDetailVC.tableView
            .cellForRowAtIndexPath(indexOfPhotoCell) as! RestaurantPhotoTableViewCell
    }
}
