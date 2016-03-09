import XCTest
import Nimble
import BrightFutures

@testable import Osusume

class ImageLoaderHandlerTest: XCTestCase {

    func test_callbackWithImage_fulfillsPromiseWithImage() {
        let image = testImage(named: "appleLogo", imageExtension: "png")

        let promise = Promise<UIImage, ImageLoadingError>()
        ImageLoaderHandler().callback(promise)(image, nil, SDImageCacheType.None, true, nil)
        expect(promise.future.result?.value).to(equal(image))
    }

    func test_callbackWithImage_fulfillsPromiseWithError_whenImageLoadError_andNoPlaceholder() {
        let promise = Promise<UIImage, ImageLoadingError>()
        ImageLoaderHandler().callback(promise)(nil, nil, SDImageCacheType.None, true, nil)
        expect(promise.future.result?.error).to(equal(ImageLoadingError.Failed))
    }
}