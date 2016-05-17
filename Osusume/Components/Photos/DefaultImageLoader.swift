import BrightFutures

struct DefaultImageLoader: ImageLoader {

    func load(url: NSURL) -> Future<UIImage, ImageLoadingError> {

        let handler = ImageLoaderHandler()
        let manager = SDWebImageManager.sharedManager()
        let promise = Promise<UIImage, ImageLoadingError>()

        manager.downloadImageWithURL(url,
            options: SDWebImageOptions(rawValue: 0),
            progress: nil,
            completed: handler.callback(promise)
        )

        return promise.future
    }
}
