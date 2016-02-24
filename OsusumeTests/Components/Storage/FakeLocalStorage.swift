@testable import Osusume

class FakeLocalStorage: LocalStorage {
    var writeToDisk_args = (data: NSData(), toUrl: NSURL())
    var writeToDisk_calls = WriteToDiskCalls()
    func writeToDisk(data: NSData, toUrl url: NSURL) {
        writeToDisk_args = (data: data, toUrl: url)

        writeToDisk_calls.record(data: data, toUrl: url)
    }
}

class WriteToDiskCalls {

    private var calls = [(data: NSData, toUrl: NSURL)]()

    var count: Int {
        return calls.count
    }

    func record(data data: NSData, toUrl: NSURL) {
        calls.append((data, toUrl))
    }
}