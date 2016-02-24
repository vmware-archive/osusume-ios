protocol SessionRepo {
    func setToken(token: String)
    func getToken() -> String?
    func deleteToken()
}
