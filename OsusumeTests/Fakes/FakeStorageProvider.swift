@testable import Osusume

class FakeStorageService: StorageService {
    var uploadFile_arg = NSURL()
    var uploadFile_returnValue = "http://example.com"
    func uploadFile(withUrl url: NSURL) -> String {
        uploadFile_arg = url
        return uploadFile_returnValue
    }
}
