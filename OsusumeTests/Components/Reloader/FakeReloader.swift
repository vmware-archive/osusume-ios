@testable import Osusume

class FakeReloader: Reloader {
    var reload_wasCalled = false
    var reload_calledNumberOfTimes = 0
    var reload_args: Reloadable!
    func reload(reloadable: Reloadable) {
        reload_wasCalled = true
        reload_calledNumberOfTimes += 1
        reload_args = reloadable
    }

    var reloadSection_args: (section: Int, reloadable: Reloadable)!
    func reloadSection(section: Int, reloadable: Reloadable) {
        reloadSection_args = (section, reloadable)
    }
}