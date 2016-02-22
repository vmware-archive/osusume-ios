import XCTest
import Nimble
import UIKit
import Foundation
@testable import Osusume

class FakeLocalStorage: LocalStorage {
    var writeToDisk_args = (data: NSData(), toUrl: NSURL())
    func writeToDisk(data: NSData, toUrl url: NSURL) {
        writeToDisk_args = (data: data, toUrl: url)
    }
}

class NetworkPhotoRepoTest: XCTestCase {
    var fakeStorageService: FakeRemoteStorage!
    var networkPhotoRepo: NetworkPhotoRepo!
    var fakeLocalStorage: FakeLocalStorage!

    override func setUp() {
        fakeStorageService = FakeRemoteStorage()
        fakeLocalStorage = FakeLocalStorage()

        networkPhotoRepo = NetworkPhotoRepo(
            remoteStorage: fakeStorageService,
            uuidProvider: FakeUUIDProvider(),
            localStorage: fakeLocalStorage
        )
    }

    func test_uploadPhoto_passesRequestToStorageService() {
        let image = testImage(named: "appleLogo", imageExtension: "png")
        networkPhotoRepo.uploadPhoto(image)

        let expectedUrl = NSURL(
            fileURLWithPath: NSTemporaryDirectory().stringByAppendingString("fakeKey")
        )

        expect(self.fakeStorageService.uploadFile_arg).to(equal(expectedUrl))
    }

    func test_uploadPhoto_returnsUploadedFileUrl() {
        let image = testImage(named: "appleLogo", imageExtension: "png")
        let actualUploadedFileUrl = networkPhotoRepo.uploadPhoto(image)

        expect(actualUploadedFileUrl).to(equal("http://example.com"))
    }

    func test_uploadPhoto_persistsImageToDiskStorage() {
        let image = testImage(named: "appleLogo", imageExtension: "png")
        networkPhotoRepo.uploadPhoto(image)

        let expectedData = UIImageJPEGRepresentation(image, 1.0)

        let expectedUrl = NSURL(
            fileURLWithPath: NSTemporaryDirectory().stringByAppendingString("fakeKey")
        )

        expect(self.fakeLocalStorage.writeToDisk_args.data).to(equal(expectedData))
        expect(self.fakeLocalStorage.writeToDisk_args.toUrl).to(equal(expectedUrl))
    }
}
