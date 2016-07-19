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
        expect(self.notesTVC.notesHeaderLabel)
            .to(beAKindOf(UILabel))
        expect(self.notesTVC.notesTextField)
            .to(beAKindOf(UITextView))
    }

    func test_viewDidLoad_addsSubviews() {
        expect(self.notesTVC.contentView)
            .to(containSubview(notesTVC.notesHeaderLabel))
        expect(self.notesTVC.contentView)
            .to(containSubview(notesTVC.notesTextField))
    }

    func test_viewDidLoad_addsConstraints() {
        expect(self.notesTVC.notesHeaderLabel)
            .to(hasConstraintsToSuperview())
        expect(self.notesTVC.notesTextField)
            .to(hasConstraintsToSuperview())
    }

    func test_cellDoesNotAppearSelected() {
        expect(self.notesTVC.selectionStyle == .None).to(beTrue())
    }
}
