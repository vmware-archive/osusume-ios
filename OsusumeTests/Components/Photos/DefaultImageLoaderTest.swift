import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class DefaultImageLoaderTest: XCTestCase {

    func testDefaultImageLoader_successfullyLoadsLocalImage() {
        let testBundle = NSBundle(forClass: ExtensionsForTest.self)
        let imagePath = testBundle.pathForResource("appleLogo", ofType: "png")!

        let url = NSURL(fileURLWithPath: imagePath)

        let imageLoader = DefaultImageLoader()
        let actualResult = imageLoader.load(url, placeholder: nil)

        NSRunLoop.osu_advance()

        if let actualImage = actualResult.result?.value {
            expect(actualImage).toNot(beNil())
            expect(actualImage).to(beAKindOf(UIImage.self))
        } else {
            XCTFail("Image not returned from Promise.")
        }
    }

    func testDefaultImageLoader_returnsPlaceholderImageOnLoadError() {
        let url = NSURL(fileURLWithPath: "/path_that_does_not_exist")

        let imageLoader = DefaultImageLoader()
        let actualResult = imageLoader.load(url, placeholder: UIImage(named: "TableCellPlaceholder"))

        NSRunLoop.osu_advance()

        let placeholderImage = UIImage(named: "TableCellPlaceholder")!
        let placeholderImageData = UIImagePNGRepresentation(placeholderImage)

        if
            let actualImage = actualResult.result?.value,
            let actualImageData = UIImagePNGRepresentation(actualImage)
        {
            expect(actualImageData).to(equal(placeholderImageData))
        } else {
            XCTFail("Image not returned from Promise.")
        }
    }

    func testDefaultImageLoader_returnsError_whenPlaceholderIsNil() {
        let url = NSURL(fileURLWithPath: "/path_that_does_not_exist")

        let imageLoader = DefaultImageLoader()
        let actualResult = imageLoader.load(url, placeholder: nil)

        NSRunLoop.osu_advance()

        if let actualError = actualResult.result?.error {
            expect(actualError).to(equal(ImageLoadingError.Failed))
        } else {
            XCTFail("Error not returned from Promise.")
        }
    }
}
