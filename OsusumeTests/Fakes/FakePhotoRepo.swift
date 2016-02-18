@testable import Osusume

class FakePhotoRepo: PhotoRepo {
    var credentialsConfigured: Bool = false
    var generatedUrlAbsoluteString: String = ""

    func configureCredentials() {
        credentialsConfigured = true
    }

    func uploadPhotoWithKey(key: String, photo: UIImage) {

    }

    func generatePhotoURLForKey(key: String) -> NSURL {
        generatedUrlAbsoluteString = "http://www.\(key).com"
        return NSURL(string: generatedUrlAbsoluteString)!
    }
}