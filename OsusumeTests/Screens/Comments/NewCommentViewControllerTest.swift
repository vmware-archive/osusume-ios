import XCTest
import BrightFutures

@testable import Osusume

class NewCommentViewControllerTest: XCTestCase {
    let fakeRestaurantId = 0

    func test_view_showsTitleInNavigationBar() {
        let fakeCommentRepo = FakeCommentRepo()

        let newCommentVC = NewCommentViewController(
            router: FakeRouter(),
            commentRepo: fakeCommentRepo,
            restaurantId: fakeRestaurantId
        )
        newCommentVC.view.setNeedsLayout()

        XCTAssertEqual("Add a comment", newCommentVC.title)
    }

    func test_displayingPlaceholderText() {
        let fakeCommentRepo = FakeCommentRepo()

        let newCommentVC = NewCommentViewController(
            router: FakeRouter(),
            commentRepo: fakeCommentRepo,
            restaurantId: fakeRestaurantId
        )
        newCommentVC.view.setNeedsLayout()

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
        let fakeCommentRepo = FakeCommentRepo()

        let newCommentVC = NewCommentViewController(
            router: FakeRouter(),
            commentRepo: fakeCommentRepo,
            restaurantId: fakeRestaurantId
        )
        newCommentVC.view.setNeedsLayout()

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
        let fakeRouter = FakeRouter()
        let fakeCommentRepo = FakeCommentRepo()

        let promise = Promise<PersistedComment, RepoError>()
        fakeCommentRepo.persist_returnValue = promise.future

        let newCommentVC = NewCommentViewController(
            router: fakeRouter,
            commentRepo: fakeCommentRepo,
            restaurantId: fakeRestaurantId
        )
        newCommentVC.view.setNeedsLayout()

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
