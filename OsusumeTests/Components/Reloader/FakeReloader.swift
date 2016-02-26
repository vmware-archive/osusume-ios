@testable import Osusume

class FakeReloader: Reloader {
    var reload_wasCalled = false
    func reload(reloadable: Reloadable) {
        reload_wasCalled = true
    }
}