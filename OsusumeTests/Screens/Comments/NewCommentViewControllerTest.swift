import XCTest
import UIKit
import BrightFutures

@testable import Osusume

func tapNavBarButton(button: UIBarButtonItem) {
    UIApplication.sharedApplication().sendAction(
        button.action,
        to: button.target,
        from: nil,
        forEvent: nil
    )
}

class NewCommentViewControllerTest: XCTestCase {
    func test_tappingSave_persistsComment() {
        let fakeCommentRepo = FakeCommentRepo()

        let newCommentVC = NewCommentViewController(
            router: FakeRouter(),
            commentRepo: fakeCommentRepo
        )

        let _ = newCommentVC.view

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

        let _ = newCommentVC.view

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
