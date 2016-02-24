@testable import Osusume

class FakeUUIDProvider: UUIDProvider {
    var uuidKey_returnValue = "fakeKey"
    func uuidKey() -> String {
        return uuidKey_returnValue
    }
}
