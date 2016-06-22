import XCTest
import Nimble
@testable import Osusume

class NotesTableViewCellTest: XCTestCase {

    var notesTVC: NotesTableViewCell!

    override func setUp() {
        notesTVC = NotesTableViewCell()
    }

    // MARK: - Initialize View
    func test_viewDidLoad_initializesSubviews() {
        expect(self.notesTVC.formView)
            .to(beAKindOf(NewRestaurantFormView))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.notesTVC.contentView)
            .to(containSubview(notesTVC.formView))
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.notesTVC.formView)
            .to(hasConstraintsToSuperview())
    }

    func test_cellDoesNotAppearSelected() {
        expect(self.notesTVC.selectionStyle == .None).to(beTrue())
    }
}
