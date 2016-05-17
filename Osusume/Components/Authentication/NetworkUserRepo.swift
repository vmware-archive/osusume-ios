import BrightFutures

struct NetworkUserRepo: UserRepo {
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
                "/session",
                headers: [:],
                parameters: ["email": email, "password": password]
            )
            .flatMap({ (json: [String : AnyObject]) -> Future<String, RepoError> in
                if let _ = json["error"] {
                    return Future(error: RepoError.PostFailed)
                }

                guard let token = json["token"] as? String else {
                    return Future(error: RepoError.PostFailed)
                }

                return Future(value: token)
            })
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
