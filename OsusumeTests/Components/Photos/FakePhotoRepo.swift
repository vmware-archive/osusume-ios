import BrightFutures
@testable import Osusume

class FakePhotoRepo: PhotoRepo {
    var loadImageFromUrl_wasCalled = false
    var loadImageFromUrl_args: (url: NSURL, placeholder: UIImage)!
    var loadImageFromUrl_returnValue = Future<UIImage, RepoError>()
    func loadImageFromUrl(url: NSURL?, placeholder: UIImage?) -> Future<UIImage, RepoError> {
        loadImageFromUrl_wasCalled = true
        loadImageFromUrl_args = (url!, placeholder!)
        return loadImageFromUrl_returnValue
    }

    var uploadPhotos_returnValue = [""]
    var uploadPhotos_arg = [UIImage]()
    func uploadPhotos(photos: [UIImage]) -> [String] {
        uploadPhotos_arg = photos
        return uploadPhotos_returnValue
    }
}