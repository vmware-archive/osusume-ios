import Foundation
import BrightFutures
import Alamofire

class NetworkUserRepo: UserRepo {
    let http: Http
    private let restaurantListRepo: RestaurantListRepo

    init(
        http: Http,
        restaurantListRepo: RestaurantListRepo
        )
    {
        self.http = http
        self.restaurantListRepo = restaurantListRepo
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

    func getMyPosts() -> Future<[Restaurant], RepoError> {
        return restaurantListRepo.getAll("/profile/posts")
    }

    func getMyLikes() -> Future<[Restaurant], RepoError> {
        return restaurantListRepo.getAll("/profile/likes")
    }
}
