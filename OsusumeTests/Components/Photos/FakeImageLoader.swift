import Foundation
import BrightFutures
@testable import Osusume

class FakeImageLoader: ImageLoader {
    var load_wasCalled = false
    var load_arguments: NSURL?
    var load_returnValue = Future<UIImage, ImageLoadingError>()
    func load(url: NSURL) -> Future<UIImage, ImageLoadingError> {
        load_wasCalled = true
        load_arguments = url
        return load_returnValue
    }
}
