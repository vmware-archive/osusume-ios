import BrightFutures

enum ImageLoadingError: ErrorType {
    case Failed
}

protocol ImageLoader {
    func load(url: NSURL, placeholder: UIImage?) -> Future<UIImage, ImageLoadingError>
}
