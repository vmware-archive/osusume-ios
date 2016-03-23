import BrightFutures
import Result

protocol CuisineRepo {
    func getAll() -> Future<[Cuisine], RepoError>
    func create(cuisine: NewCuisine) -> Future<Cuisine, RepoError>
}

struct HttpCuisineRepo <P: DataListParser where P.ParsedObject == [Cuisine]>: CuisineRepo {
    let http: Http
    let parser: P

    func getAll() -> Future<[Cuisine], RepoError> {
        return http
            .get("/cuisines", headers: [:])
            .flatMap { json in
                return self.parser
                    .parse(json as! [[String : AnyObject]])
                        .mapError {
                            _ in return RepoError.GetFailed
                        }
            }
    }

    func create(cuisine: NewCuisine) -> Future<Cuisine, RepoError> {
        return http.post(
                "/cuisines",
                headers: [:],
                parameters: ["name" : cuisine.name]
            )
            .flatMap { (json: [String: AnyObject]) -> Result<Cuisine, RepoError> in
                return CuisineParser().parse(json)
                    .mapError { _ in RepoError.PostFailed }
            }

    }
}
