@testable import Osusume

class FakePhotoRepo: PhotoRepo {
    var uploadPhotos_returnValue = [""]
    var uploadPhotos_arg = [UIImage]()
    func uploadPhotos(photos: [UIImage]) -> [String] {
        uploadPhotos_arg = photos
        return uploadPhotos_returnValue
    }
}