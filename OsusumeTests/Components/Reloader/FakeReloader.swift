@testable import Osusume

class FakeReloader: Reloader {
    var reload_wasCalled = false
    var reload_args: Reloadable!
    func reload(reloadable: Reloadable) {
        reload_wasCalled = true
        reload_args = reloadable
    }
}