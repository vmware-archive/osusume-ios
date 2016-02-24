import XCTest
import Nimble
import UIKit
import Foundation
@testable import Osusume

class NetworkPhotoRepoTest: XCTestCase {
    var fakeRemoteStorage: FakeRemoteStorage!
    var fakeUuidProvider: FakeUUIDProvider!
    var networkPhotoRepo: NetworkPhotoRepo!
    var fakeLocalStorage: FakeLocalStorage!

    override func setUp() {
        fakeRemoteStorage = FakeRemoteStorage()
        fakeLocalStorage = FakeLocalStorage()
        fakeUuidProvider = FakeUUIDProvider()

        networkPhotoRepo = NetworkPhotoRepo(
            remoteStorage: fakeRemoteStorage,
            uuidProvider: fakeUuidProvider,
            localStorage: fakeLocalStorage
        )
    }

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
