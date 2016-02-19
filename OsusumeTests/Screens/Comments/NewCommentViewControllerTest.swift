import XCTest
import UIKit
import BrightFutures

@testable import Osusume

class NewCommentViewControllerTest: XCTestCase {
    func test_view_showsTitleInNavigationBar() {
        let fakeCommentRepo = FakeCommentRepo()

        let newCommentVC = NewCommentViewController(
            router: FakeRouter(),
            commentRepo: fakeCommentRepo
        )
        newCommentVC.view.setNeedsLayout()

        XCTAssertEqual("Add a comment", newCommentVC.navigationItem.title)
    }

    func test_displayingPlaceholderText() {
        let fakeCommentRepo = FakeCommentRepo()

        let newCommentVC = NewCommentViewController(
            router: FakeRouter(),
            commentRepo: fakeCommentRepo
        )
        newCommentVC.view.setNeedsLayout()

        XCTAssertEqual(
            newCommentVC.hash,
            newCommentVC.commentTextField.delegate?.hash
        )

        let _ = newCommentVC.view
        XCTAssertEqual(newCommentVC.commentTextField.text, "Add a comment")

        newCommentVC.textViewDidBeginEditing(newCommentVC.commentTextField)
        XCTAssertNotEqual(newCommentVC.commentTextField.text, "Add a comment")

        newCommentVC.textViewDidEndEditing(newCommentVC.commentTextField)
        XCTAssertEqual(newCommentVC.commentTextField.text, "Add a comment")

        newCommentVC.commentTextField.text = "Here's my comment"
        newCommentVC.textViewDidBeginEditing(newCommentVC.commentTextField)
        XCTAssertEqual(newCommentVC.commentTextField.text, "Here's my comment")
    }

    func test_tappingSave_persistsComment() {
        let fakeCommentRepo = FakeCommentRepo()

        let newCommentVC = NewCommentViewController(
            router: FakeRouter(),
            commentRepo: fakeCommentRepo
        )
        newCommentVC.view.setNeedsLayout()

        newCommentVC.commentTextField.text = "No parking in Harvard Yard"

        let saveButton = newCommentVC.navigationItem.rightBarButtonItem
        tapNavBarButton(saveButton!)

        let expectedComment = NewComment(text: "No parking in Harvard Yard")

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
            commentRepo: fakeCommentRepo
        )
        newCommentVC.view.setNeedsLayout()

        let saveButton = newCommentVC.navigationItem.rightBarButtonItem
        tapNavBarButton(saveButton!)

        promise.success(
            PersistedComment(
                id: 123,
                text: "Saved comment"
            )
        )

        NSRunLoop.osu_advance()

        XCTAssertTrue(fakeRouter.dismissNewCommentScreen_wasCalled)
    }
}
