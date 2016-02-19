import XCTest
import Nimble
@testable import Osusume

class NetworkPhotoRepoTest: XCTestCase {

    func test_uploadPhoto_passesRequestToStorageService() {
        let fakeStorageService = FakeStorageService()

        let networkPhotoRepo = NetworkPhotoRepo(
            storageService: fakeStorageService,
            uuidProvider: FakeUUIDProvider()
        )

        let image = UIImage(named: "Jeana")!
        networkPhotoRepo.uploadPhoto(image)

        let expectedUrl = NSURL(
            fileURLWithPath: NSTemporaryDirectory().stringByAppendingString("fakeKey")
        )

        expect(fakeStorageService.uploadFile_arg).to(equal(expectedUrl))
    }

    func test_uploadPhoto_returnsUploadedFileUrl() {
        let fakeStorageService = FakeStorageService()

        let networkPhotoRepo = NetworkPhotoRepo(
            storageService: fakeStorageService,
            uuidProvider: FakeUUIDProvider()
        )

        let image = UIImage(named: "Jeana")!
        let actualUploadedFileUrl = networkPhotoRepo.uploadPhoto(image)

        expect(actualUploadedFileUrl).to(equal("http://example.com"))
    }

}
