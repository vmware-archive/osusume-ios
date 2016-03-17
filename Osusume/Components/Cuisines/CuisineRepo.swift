import BrightFutures
import Result

protocol CuisineRepo {
    func getAll() -> Future<CuisineList, RepoError>
}

struct HttpCuisineRepo <P: DataListParser where P.ParsedObject == CuisineList>: CuisineRepo {
    let http: Http
    let sessionRepo: SessionRepo
    let parser: P

    func getAll() -> Future<CuisineList, RepoError> {
        return http
            .get("/cuisines", headers: buildHeaders()) // Future<AnyObject, RepoError>
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

    private func buildHeaders() -> [String : String] {
        return [
            "Authorization": "Bearer \(sessionRepo.getToken()!)"
        ]
    }
}
