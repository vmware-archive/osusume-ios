import Foundation
import BrightFutures
@testable import Osusume

class FakeImageLoader: ImageLoader {
    var load_wasCalled = false
    var load_arguments: (url: NSURL, placeholder: UIImage?)!
    var load_returnValue = Future<UIImage, ImageLoadingError>()
    func load(url: NSURL, placeholder: UIImage?) -> Future<UIImage, ImageLoadingError> {
        load_wasCalled = true
        load_arguments = (url, placeholder)
        return load_returnValue
    }
}
