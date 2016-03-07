import BrightFutures

struct NetworkPhotoRepo: PhotoRepo {
    let remoteStorage: RemoteStorage
    let uuidProvider: UUIDProvider
    let localStorage: LocalStorage
    let imageLoader: ImageLoader

    func loadImageFromUrl(url: NSURL?, placeholder: UIImage?) -> Future<UIImage, RepoError> {
        if let url = url {
             return imageLoader.load(url, placeholder: placeholder)
                .mapError { _ in RepoError.GetFailed }
        }

        return Future()
    }

    func uploadPhotos(photos: [UIImage]) -> [String] {
        return photos.map { photo in uploadPhoto(photo) }
    }

    private func uploadPhoto(photo: UIImage) -> String {
        let fileName = uuidProvider.uuidKey()

        let photoTempURL = NSURL(
            fileURLWithPath: NSTemporaryDirectory() + fileName
        )

        let imageData = UIImageJPEGRepresentation(photo, 1.0)!
        localStorage.writeToDisk(imageData, toUrl: photoTempURL)

        return remoteStorage.uploadFile(withUrl: photoTempURL)
    }
}
