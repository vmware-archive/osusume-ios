import BrightFutures
import Result

protocol CuisineRepo {
    func getAll() -> Future<CuisineList, RepoError>
}

struct HttpCuisineRepo <P: DataListParser where P.ParsedObject == CuisineList>: CuisineRepo {
    let http: Http
    let parser: P

    func getAll() -> Future<CuisineList, RepoError> {
        return http
            .get("/cuisines", headers: [:]) // Future<AnyObject, RepoError>
            .mapError {
                _ in return RepoError.GetFailed
            }
            .flatMap { json in
                return self.parser
                    .parse(json as! [[String : AnyObject]]) // Result<CuisineList, ParseError>
                        .mapError {
                            _ in return RepoError.GetFailed
                        }
            }
    }
}
