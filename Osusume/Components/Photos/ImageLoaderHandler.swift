import BrightFutures

class ImageLoaderHandler {
    func callback(promise: Promise<UIImage, ImageLoadingError>) -> (UIImage!, NSError!, SDImageCacheType, Bool, NSURL!) -> () {
        return {(
            image: UIImage!,
            error: NSError!,
            cacheType: SDImageCacheType,
            finished: Bool,
            imageURL: NSURL!) -> () in
            if image != nil {
                promise.success(image)
            } else {
                promise.failure(ImageLoadingError.Failed)
            }
        }
    }
}