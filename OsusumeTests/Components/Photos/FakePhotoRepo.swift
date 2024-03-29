import BrightFutures
@testable import Osusume

class FakePhotoRepo: PhotoRepo {
    var loadImageFromUrl_wasCalled = false
    var loadImageFromUrl_args: NSURL?
    var loadImageFromUrl_returnValue = Future<UIImage, RepoError>()
    func loadImageFromUrl(url: NSURL?) -> Future<UIImage, RepoError> {
        loadImageFromUrl_wasCalled = true
        loadImageFromUrl_args = url!
        return loadImageFromUrl_returnValue
    }

    var uploadPhotos_returnValue = [""]
    var uploadPhotos_arg = [UIImage]()
    func uploadPhotos(photos: [UIImage]) -> [String] {
        uploadPhotos_arg = photos
        return uploadPhotos_returnValue
    }

    var deletePhoto_wasCalled = false
    var deletePhoto_args: (restaurantId: Int, photoUrlId: Int) = (restaurantId: -1, photoUrlId: -1)
    func deletePhoto(restaurantId: Int, photoUrlId: Int) {
        deletePhoto_wasCalled = true
        deletePhoto_args = (restaurantId: restaurantId, photoUrlId: photoUrlId)
    }
}