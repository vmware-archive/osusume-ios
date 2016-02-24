@testable import Osusume

class FakeRemoteStorage: RemoteStorage {
    var uploadFile_arg = NSURL()
    var uploadFile_returnValue = "http://example.com"
    var uploadFile_calls = UploadFileCalls()
    func uploadFile(withUrl url: NSURL) -> String {
        uploadFile_arg = url

        uploadFile_calls.record(argument: uploadFile_arg)

        return uploadFile_returnValue
    }
}

class UploadFileCalls {
    private var calls = [NSURL]()

    var count: Int {
        return calls.count
    }

    func record(argument argument: NSURL) {
        calls.append(argument)
    }

    var firstArgument: NSURL {
        return calls.first!
    }
}
