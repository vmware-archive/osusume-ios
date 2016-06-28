import BrightFutures

protocol PriceRangeRepo {
    func getAll() -> Future<[PriceRange], RepoError>
}

struct NetworkPriceRangeRepo<P: DataParser where P.ParsedObject == [PriceRange]>: PriceRangeRepo {
    let http: Http
    let parser: P

    func getAll() -> Future<[PriceRange], RepoError> {
        return http
            .get("/priceranges", headers: [:])
            .mapError { _ in
                return RepoError.GetFailed
            }
            .flatMap { httpJson in
                return self.parser
                    .parse(httpJson)
                    .mapError { _ in
                        return RepoError.ParsingFailed
                }
            }
    }
}