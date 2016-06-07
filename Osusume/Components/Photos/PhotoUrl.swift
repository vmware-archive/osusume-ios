struct PhotoUrl {
    let id: Int
    let url: NSURL
}

extension PhotoUrl: Equatable {}

func ==(lhs: PhotoUrl, rhs: PhotoUrl) -> Bool {
    return lhs.id == rhs.id &&
        lhs.url == rhs.url
}
