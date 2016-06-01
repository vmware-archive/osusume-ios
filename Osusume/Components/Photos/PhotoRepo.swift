import BrightFutures

protocol PhotoRepo {
    func loadImageFromUrl(url: NSURL?) -> Future<UIImage, RepoError>
    func uploadPhotos(photos: [UIImage]) -> [String]
    func deletePhoto(url: NSURL)
}
