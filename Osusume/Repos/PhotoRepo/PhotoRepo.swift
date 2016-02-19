protocol PhotoRepo {
    func configureCredentials()

    func uploadPhoto(photo: UIImage) -> String
}
