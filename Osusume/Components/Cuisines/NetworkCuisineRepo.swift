import BrightFutures
import Result

struct NetworkCuisineRepo<P: DataParser where P.ParsedObject == [Cuisine]>: CuisineRepo {
    let http: Http
    let parser: P

    func getAll() -> Future<[Cuisine], RepoError> {
        return http
        .get("/cuisines", headers: [:])
        .flatMap { json in
            return self.parser
            .parse(json)
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
        .flatMap { json in
            return CuisineParser().parse(json)
            .mapError { _ in RepoError.PostFailed }
        }

    }
}
