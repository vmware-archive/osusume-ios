import XCTest
import BrightFutures
import Nimble
@testable import Osusume

enum HttpError: ErrorType {
    case UnspecifiedError
}

class S3StorageIntegrationTest: XCTestCase {

    func test_verify_uploadedFileToS3() {
        let documentDirectoryURL = try! NSFileManager.defaultManager()
            .URLForDirectory(
                .DocumentDirectory,
                inDomain: .UserDomainMask,
                appropriateForURL: nil, create: true
            )

        let todaysDate = NSDate().timeIntervalSince1970
        let fileToUploadUrl = documentDirectoryURL.URLByAppendingPathComponent("file-\(todaysDate).txt")
        let fileData: NSData! = "file-data".dataUsingEncoding(NSUTF8StringEncoding)
        fileData.writeToURL(fileToUploadUrl, atomically: true)


        let s3Storage = S3Storage()
        let uploadedUrlString = s3Storage.uploadFile(withUrl: fileToUploadUrl)
        NSRunLoop.osu_advance(by: 5)


        let fileDownloadFuture = downloadFileAtUrl(NSURL(string: uploadedUrlString)!)
        waitForFutureToComplete(fileDownloadFuture)

        XCTAssertEqual(fileDownloadFuture.value, fileData)
    }

    private func downloadFileAtUrl(url: NSURL) -> Future<NSData, HttpError> {
        let promise = Promise<NSData, HttpError>()
        let request = NSURLRequest(URL: url)
        let sharedSession = NSURLSession.sharedSession()

        sharedSession.dataTaskWithRequest(request)
            { (maybeData, maybeResponse, maybeError) -> Void in
                if let data = maybeData {
                    promise.success(data)
                } else {
                    promise.failure(.UnspecifiedError)
                }
            }.resume()

        return promise.future
    }

    private func waitForFutureToComplete<T, E>(future: Future<T, E>) {
        waitUntil { done in
            while !future.isCompleted {}
            done()
        }
    }
}

private let oneHundredthOfASecond: NSTimeInterval = 0.01
extension NSRunLoop {
    static func osu_advance(by timeInterval: NSTimeInterval = oneHundredthOfASecond) {
        let stopDate = NSDate().dateByAddingTimeInterval(timeInterval)
        mainRunLoop().runUntilDate(stopDate)
    }
}
