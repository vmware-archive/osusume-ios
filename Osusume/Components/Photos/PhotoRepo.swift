import BrightFutures

protocol PhotoRepo {
    func loadImageFromUrl(url: NSURL?, placeholder: UIImage?) -> Future<UIImage, RepoError>

    func uploadPhotos(photos: [UIImage]) -> [String]
}
