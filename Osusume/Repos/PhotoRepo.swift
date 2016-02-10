protocol PhotoRepo {
    func configureCredentials()
    func uploadPhotoWithKey(key: String, photo: UIImage)
    func generatePhotoURLForKey(key: String) -> NSURL
}
