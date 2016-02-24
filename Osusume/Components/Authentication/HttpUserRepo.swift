import Foundation
import BrightFutures
import Alamofire

class HttpUserRepo: UserRepo {
    let http: Http

    init(http: Http) {
        self.http = http
    }

    func login(email: String, password: String) -> Future<String, RepoError> {
        return http
            .post(
                "/login",
                headers: [String: String](),
                parameters: ["email": email, "password": password]
            )
            .map { value in value["token"] as! String }
    }
}
