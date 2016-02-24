import BrightFutures
@testable import Osusume

class FakeUserRepo : UserRepo {
    var submittedEmail : String? = nil
    var submittedPassword : String? = nil

    var stringPromise = Promise<String, RepoError>()

    func login(email : String, password: String) -> Future<String, RepoError> {
        stringPromise.success("token-value")

        self.submittedEmail = email
        self.submittedPassword = password

        return stringPromise.future
    }
}
