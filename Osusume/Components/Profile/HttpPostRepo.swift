import BrightFutures
import Alamofire

struct HttpPostRepo: PostRepo {
    let parser: RestaurantParser
    let path: String
    let http: Http
    let sessionRepo: SessionRepo

    init(http: Http, sessionRepo: SessionRepo) {
        self.parser = RestaurantParser()
        self.path = "/profile/posts"
        self.http = http
        self.sessionRepo = sessionRepo
    }

    //MARK: - GET Functions
    func getAll() -> Future<[Restaurant], RepoError> {
        return http
            .get(path, headers: buildHeaders())
            .map { value in
                self.parser
                    .parseList(value as! [[String: AnyObject]]).value!
        }
    }

    // MARK: - Private Methods
    private func buildHeaders() -> [String: String] {
        return [
            "Authorization": "Bearer \(sessionRepo.getToken()!)"
        ]
    }
}