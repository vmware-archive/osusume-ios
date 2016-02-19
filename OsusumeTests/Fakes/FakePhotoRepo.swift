@testable import Osusume

class FakePhotoRepo: PhotoRepo {
    var credentialsConfigured: Bool = false
    var generatedUrlAbsoluteString: String = ""

    func configureCredentials() {
        credentialsConfigured = true
    }

    var uploadPhoto_returnValue = ""
    var uploadPhoto_arg = UIImage(named: "")
    func uploadPhoto(photo: UIImage) -> String {
        uploadPhoto_arg = (photo: photo)
        return uploadPhoto_returnValue
    }

    func generatePhotoURLForKey(key: String) -> NSURL {
        generatedUrlAbsoluteString = "http://www.\(key).com"
        return NSURL(string: generatedUrlAbsoluteString)!
    }
}