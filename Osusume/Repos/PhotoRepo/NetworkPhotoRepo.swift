struct NetworkPhotoRepo: PhotoRepo {
    let storageService: RemoteStorage
    let uuidProvider: UUIDProvider

    func uploadPhoto(photo: UIImage) -> String {
        let fileName = uuidProvider.uuidKey()

        let photoTempURL = NSURL(
            fileURLWithPath: NSTemporaryDirectory().stringByAppendingString(fileName)
        )

        UIImageJPEGRepresentation(photo, 1.0)?.writeToURL(photoTempURL, atomically: true)

        return storageService.uploadFile(withUrl: photoTempURL)
    }
}
