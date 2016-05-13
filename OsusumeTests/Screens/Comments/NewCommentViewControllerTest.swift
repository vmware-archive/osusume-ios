import XCTest
import Nimble
import BrightFutures

@testable import Osusume

class NewCommentViewControllerTest: XCTestCase {
    var fakeRouter: FakeRouter!
    var fakeCommentRepo: FakeCommentRepo!
    var promise: Promise<PersistedComment, RepoError>!
    var newCommentVC: NewCommentViewController!
    let fakeRestaurantId = 0

    override func setUp() {
        fakeRouter = FakeRouter()
        fakeCommentRepo = FakeCommentRepo()

        promise = Promise<PersistedComment, RepoError>()
        fakeCommentRepo.persist_returnValue = promise.future

        newCommentVC = NewCommentViewController(
            router: fakeRouter,
            commentRepo: fakeCommentRepo,
            restaurantId: fakeRestaurantId
        )
        newCommentVC.view.setNeedsLayout()
    }

    func test_viewDidLoad_initializesSubviews() {
        expect(self.newCommentVC.commentTextView)
            .to(beAKindOf(UITextView))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.newCommentVC.view)
            .to(containSubview(newCommentVC.commentTextView))
    }

    func test_viewDidLoad_showsTitleInNavigationBar() {
        XCTAssertEqual("Add a comment", newCommentVC.title)
    }

    func test_configureNavigationBar_addsSaveButton() {
        expect(self.newCommentVC.navigationItem.rightBarButtonItem?.title)
            .to(equal("Save"))
    }

    func test_displayingPlaceholderText() {
        XCTAssertEqual(
            newCommentVC.hash,
            newCommentVC.commentTextView.delegate?.hash
        )

        let _ = newCommentVC.view
        XCTAssertEqual(newCommentVC.commentTextView.text, "Add a comment")

        newCommentVC.textViewDidBeginEditing(newCommentVC.commentTextView)
        XCTAssertNotEqual(newCommentVC.commentTextView.text, "Add a comment")

        newCommentVC.textViewDidEndEditing(newCommentVC.commentTextView)
        XCTAssertEqual(newCommentVC.commentTextView.text, "Add a comment")

        newCommentVC.commentTextView.text = "Here's my comment"
        newCommentVC.textViewDidBeginEditing(newCommentVC.commentTextView)
        XCTAssertEqual(newCommentVC.commentTextView.text, "Here's my comment")
    }

    func test_tappingSave_persistsComment() {
        newCommentVC.commentTextView.text = "No parking in Harvard Yard"

        let saveButton = newCommentVC.navigationItem.rightBarButtonItem
        tapNavBarButton(saveButton!)

        let expectedComment = NewComment(
            text: "No parking in Harvard Yard",
            restaurantId: fakeRestaurantId
        )

        XCTAssertTrue(fakeCommentRepo.persist_wasCalled)
        XCTAssertEqual(expectedComment, fakeCommentRepo.persist_arg)
    }

    func test_tappingSave_transitionsBackToDetailView() {
        let saveButton = newCommentVC.navigationItem.rightBarButtonItem
        tapNavBarButton(saveButton!)

        promise.success(
            PersistedComment(
                id: 123,
                text: "Saved comment",
                createdDate: NSDate(),
                restaurantId: fakeRestaurantId,
                userName: ""
            )
        )

        NSRunLoop.osu_advance()

        XCTAssertTrue(fakeRouter.dismissNewCommentScreen_wasCalled)
    }
}
