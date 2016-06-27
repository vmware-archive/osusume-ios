import BrightFutures

struct NetworkUserRepo: UserRepo {
    let http: Http
    private let restaurantListRepo: RestaurantListRepo
    private let sessionRepo: SessionRepo

    init(
        http: Http,
        restaurantListRepo: RestaurantListRepo,
        sessionRepo: SessionRepo
        )
    {
        self.http = http
        self.restaurantListRepo = restaurantListRepo
        self.sessionRepo = sessionRepo
    }

    func login(email: String, password: String) -> Future<AuthenticatedUser, RepoError> {
        return http
            .post(
                "/session",
                headers: [:],
                parameters: ["email": email, "password": password]
            )
            .flatMap { (json: AnyObject) -> Future<AuthenticatedUser, RepoError> in
                guard
                    let token = json["token"] as? String,
                    let email = json["email"] as? String,
                    let id = json["id"] as? Int,
                    let name = json["name"] as? String
                else {
                    return Future(error: RepoError.PostFailed)
                }

                return Future(
                    value: AuthenticatedUser(id: id, email: email, token: token, name: name)
                )
            }
    }

    func logout() {
        guard let token = sessionRepo.getAuthenticatedUser()?.token else { return }

        http.delete(
            "/session",
            headers: [:],
            parameters: ["token": token]
        )
    }

    func getMyPosts() -> Future<[Restaurant], RepoError> {
        return restaurantListRepo.getAll("/profile/posts")
    }

    func getMyLikes() -> Future<[Restaurant], RepoError> {
        return restaurantListRepo.getAll("/profile/likes")
    }
}
