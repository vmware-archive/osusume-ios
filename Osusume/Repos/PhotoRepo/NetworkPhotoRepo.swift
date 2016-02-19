protocol LocalStorage {
    func writeToDisk(data: NSData, toUrl url: NSURL)
}

struct DiskStorage: LocalStorage {
    func writeToDisk(data: NSData, toUrl url: NSURL) {
        data.writeToURL(url, atomically: true)
    }
}

struct NetworkPhotoRepo: PhotoRepo {
    let storageService: RemoteStorage
    let uuidProvider: UUIDProvider
    let localStorage: LocalStorage

    func uploadPhoto(photo: UIImage) -> String {
        let fileName = uuidProvider.uuidKey()

        let photoTempURL = NSURL(
            fileURLWithPath: NSTemporaryDirectory() + fileName
        )

        let imageData = UIImageJPEGRepresentation(photo, 1.0)!
        localStorage.writeToDisk(imageData, toUrl: photoTempURL)

        return storageService.uploadFile(withUrl: photoTempURL)
    }
}
