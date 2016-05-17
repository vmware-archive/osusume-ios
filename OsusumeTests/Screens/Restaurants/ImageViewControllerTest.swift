import XCTest
import Nimble
@testable import Osusume

class ImageViewControllerTest: XCTestCase {
    var imageVC: ImageViewController!
    let url = NSURL(string: "my-awesome-url")

    override func setUp() {
        imageVC = ImageViewController(url: url!)
        imageVC.view.setNeedsLayout()
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_setsTitle() {
        expect(self.imageVC.title).to(equal("Photo"))
    }

    func test_viewDidLoad_getsImage() {
        expect(self.imageVC.imageView.sd_imageURL()).to(equal(url!))
    }
}