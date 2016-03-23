import BrightFutures
import Result

protocol CuisineRepo {
    func getAll() -> Future<[Cuisine], RepoError>
}

struct HttpCuisineRepo <P: DataListParser where P.ParsedObject == [Cuisine]>: CuisineRepo {
    let http: Http
    let parser: P

    func getAll() -> Future<[Cuisine], RepoError> {
        return http
            .get("/cuisines", headers: [:]) // Future<AnyObject, RepoError>
            .mapError {
                _ in return RepoError.GetFailed
            }
            .flatMap { json in
                return self.parser
                    .parse(json as! [[String : AnyObject]]) // Result<[Cuisine], ParseError>
                        .mapError {
                            _ in return RepoError.GetFailed
                        }
            }
    }
}
