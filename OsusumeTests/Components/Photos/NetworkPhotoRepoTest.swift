import XCTest
import Nimble
import BrightFutures
@testable import Osusume

class NetworkPhotoRepoTest: XCTestCase {
    var fakeRemoteStorage: FakeRemoteStorage!
    var fakeUuidProvider: FakeUUIDProvider!
    var networkPhotoRepo: NetworkPhotoRepo!
    var fakeLocalStorage: FakeLocalStorage!
    var fakeImageLoader: FakeImageLoader!

    override func setUp() {
        fakeRemoteStorage = FakeRemoteStorage()
        fakeLocalStorage = FakeLocalStorage()
        fakeUuidProvider = FakeUUIDProvider()
        fakeImageLoader = FakeImageLoader()

        networkPhotoRepo = NetworkPhotoRepo(
            remoteStorage: fakeRemoteStorage,
            uuidProvider: fakeUuidProvider,
            localStorage: fakeLocalStorage,
            imageLoader: fakeImageLoader
        )
    }

    // MARK: - loadImageFromUrl
    func test_loadImageFromUrl_delegatesToImageLoader() {
        let url = NSURL(string: "my-awesome-url")!

        networkPhotoRepo.loadImageFromUrl(url)

        expect(self.fakeImageLoader.load_wasCalled).to(equal(true))
        expect(self.fakeImageLoader.load_arguments).to(equal(url))
    }

    func test_loadImageFromUrl_doesNothingWithInvalidUrls() {
        let url = NSURL(string: "invalid url")

        networkPhotoRepo.loadImageFromUrl(url)

        expect(self.fakeImageLoader.load_wasCalled).to(equal(false))
    }

    func test_loadImageFromUrl_loadsImage() {
        let url = NSURL(string: "my-awesome-url")

        let promise = Promise<UIImage, ImageLoadingError>()
        self.fakeImageLoader.load_returnValue = promise.future

        let actualResult = networkPhotoRepo.loadImageFromUrl(url)

        promise.success(testImage(named: "appleLogo", imageExtension: "png"))
        waitForFutureToComplete(promise.future)

        if let actualImage = actualResult.result?.value {
            let actualImageData = UIImageJPEGRepresentation(actualImage, 1.0)

            let expectedImage = testImage(named: "appleLogo", imageExtension: "png")
            let expectedImageData = UIImageJPEGRepresentation(expectedImage, 1.0)

            expect(actualImageData).to(equal(expectedImageData))
        } else {
            XCTFail("Image not returned from Promise.")
        }
    }

    func test_loadImageFromUrl_mapsFailuresToRepoErrors() {
        let url = NSURL(string: "my-awesome-url")

        let promise = Promise<UIImage, ImageLoadingError>()
        self.fakeImageLoader.load_returnValue = promise.future

        let actualResult = networkPhotoRepo.loadImageFromUrl(url)

        promise.failure(.Failed)
        waitForFutureToComplete(promise.future)

        expect(actualResult.result?.error).to(equal(RepoError.GetFailed))
    }


    // MARK: - uploadPhotos
    func test_uploadPhotos_passesRequestToStorageService() {
        let appleImage = testImage(named: "appleLogo", imageExtension: "png")
        fakeUuidProvider.uuidKey_returnValue = "my-cool-filename"

        networkPhotoRepo.uploadPhotos([appleImage])

        let firstExpectedUrl = NSURL(
            fileURLWithPath: NSTemporaryDirectory().stringByAppendingString("my-cool-filename")
        )

        expect(self.fakeRemoteStorage.uploadFile_calls.firstArgument)
            .to(equal(firstExpectedUrl))
    }

    func test_uploadPhotos_returnsUploadedFileUrls() {
        let image = testImage(named: "appleLogo", imageExtension: "png")
        fakeRemoteStorage.uploadFile_returnValue = "some-image-url"

        let actualUploadedFileUrls = networkPhotoRepo.uploadPhotos([image])

        expect(actualUploadedFileUrls).to(equal(["some-image-url"]))
    }

    func test_uploadPhotos_persistsImagesToDiskStorage() {
        let image = testImage(named: "appleLogo", imageExtension: "png")

        networkPhotoRepo.uploadPhotos([image])

        let expectedData = UIImageJPEGRepresentation(image, 1.0)
        let expectedUrl = NSURL(
            fileURLWithPath: NSTemporaryDirectory().stringByAppendingString("fakeKey")
        )

        expect(self.fakeLocalStorage.writeToDisk_args.data).to(equal(expectedData))
        expect(self.fakeLocalStorage.writeToDisk_args.toUrl).to(equal(expectedUrl))
    }

    func test_uploadPhotos_handlesMultipleImages() {
        let appleImage = testImage(named: "appleLogo", imageExtension: "png")
        let truckImage = testImage(named: "truck", imageExtension: "png")
        fakeUuidProvider.uuidKey_returnValue = "my-cool-filename"

        networkPhotoRepo.uploadPhotos([appleImage, truckImage])

        expect(self.fakeLocalStorage.writeToDisk_calls.count).to(equal(2))
        expect(self.fakeRemoteStorage.uploadFile_calls.count).to(equal(2))
    }
}
