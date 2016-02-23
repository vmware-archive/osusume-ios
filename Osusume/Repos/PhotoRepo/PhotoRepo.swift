protocol PhotoRepo {
    func uploadPhotos(photos: [UIImage]) -> [String]
}
