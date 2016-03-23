import Foundation
import BrightFutures
import Alamofire

class NetworkUserRepo: UserRepo {
    let http: Http
    init(http: Http) {
        self.http = http
    }

    func login(email: String, password: String) -> Future<String, RepoError> {
        return http
            .post(
                "/login",
                headers: [:],
                parameters: ["email": email, "password": password]
            )
            .map { value in value["token"] as! String }
    }

    func fetchCurrentUserName() -> Future<String, RepoError> {
        return http
            .get("/profile", headers: [:])
            .map { value in
                value["name"] as! String
            }
    }
}
