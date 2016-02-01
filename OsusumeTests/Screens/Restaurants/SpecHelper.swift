import Quick
@testable import Osusume

class SetupAndTeardownSpec: QuickSpec {
    override func spec() {
        afterSuite {
            SessionRepo().deleteToken()
        }
    }
}