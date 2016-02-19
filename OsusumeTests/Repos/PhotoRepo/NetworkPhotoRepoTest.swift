import XCTest
import Nimble
@testable import Osusume

class NetworkPhotoRepoTest: XCTestCase {
    var fakeStorageService: FakeStorage!
    var networkPhotoRepo: NetworkPhotoRepo!

    override func setUp() {
        fakeStorageService = FakeStorage()

        networkPhotoRepo = NetworkPhotoRepo(
            storageService: fakeStorageService,
            uuidProvider: FakeUUIDProvider()
        )
    }

    func test_uploadPhoto_passesRequestToStorageService() {
        let image = UIImage(named: "Jeana")!
        networkPhotoRepo.uploadPhoto(image)

        let expectedUrl = NSURL(
            fileURLWithPath: NSTemporaryDirectory().stringByAppendingString("fakeKey")
        )

        expect(self.fakeStorageService.uploadFile_arg).to(equal(expectedUrl))
    }

    func test_uploadPhoto_returnsUploadedFileUrl() {
        let image = UIImage(named: "Jeana")!
        let actualUploadedFileUrl = networkPhotoRepo.uploadPhoto(image)

        expect(actualUploadedFileUrl).to(equal("http://example.com"))
    }

}
