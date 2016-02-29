import XCTest
import Nimble
@testable import Osusume

class ImageViewControllerTest: XCTestCase {
    func test_viewDidLoad_getsImage() {
        let url = NSURL(string: "my-awesome-url")
        let imageVC = ImageViewController(url: url!)
        imageVC.view.setNeedsLayout()

        expect(imageVC.imageView.sd_imageURL()).to(equal(url!))
    }
}