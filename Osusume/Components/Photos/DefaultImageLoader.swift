import BrightFutures

class DefaultImageLoader: ImageLoader {

    func load(url: NSURL, placeholder: UIImage?) -> Future<UIImage, ImageLoadingError> {

        let manager = SDWebImageManager.sharedManager()
        let promise = Promise<UIImage, ImageLoadingError>()

        manager.downloadImageWithURL(url,
            options: SDWebImageOptions(rawValue: 0),
            progress: nil,
            completed: {(
                image: UIImage!,
                error: NSError!,
                cacheType: SDImageCacheType,
                finished: Bool,
                imageURL: NSURL!) in

                if image != nil {
                    promise.success(image)
                } else {
                    if let placeholderImage = placeholder {
                        promise.success(placeholderImage)
                    } else {
                        promise.failure(ImageLoadingError.Failed)
                    }
                }
            }
        )

        return promise.future
    }
}
