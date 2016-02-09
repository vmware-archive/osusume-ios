@testable import Osusume

class FakePhotoRepo: PhotoRepo {
    var configured: Bool = false

    func configureCredentials() {
        configured = true
    }
}