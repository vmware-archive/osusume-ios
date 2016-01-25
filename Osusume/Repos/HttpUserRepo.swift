import Foundation
import BrightFutures
import Alamofire


class HttpUserRepo: UserRepo {
    let http: Http

    init(http: Http) {
        self.http = http
    }

    func login(email: String, password: String) -> Future<String, RepoError> {
        return http.post("/login", parameters: ["email": email, "password": password]).map { value in
            return (value["token"] as! String)
        }
    }
}
