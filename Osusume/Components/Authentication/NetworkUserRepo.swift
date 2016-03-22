import Foundation
import BrightFutures
import Alamofire

class NetworkUserRepo: UserRepo {
    let http: Http
    let sessionRepo: SessionRepo
    init(http: Http, sessionRepo: SessionRepo) {
        self.http = http
        self.sessionRepo = sessionRepo
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

    func fetchCurrentUserName() -> Future<String, RepoError> {
        return http
            .get("/profile", headers: buildHeaders())
            .map { value in
                value["name"] as! String
            }
    }

    private func buildHeaders() -> [String: String] {
        return [
            "Authorization": "Bearer \(sessionRepo.getToken()!)"
        ]
    }
}
