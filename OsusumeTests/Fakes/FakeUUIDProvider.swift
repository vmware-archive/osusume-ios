@testable import Osusume

class FakeUUIDProvider: UUIDProvider {
    func uuidKey() -> String {
        return "fakeKey"
    }
}
