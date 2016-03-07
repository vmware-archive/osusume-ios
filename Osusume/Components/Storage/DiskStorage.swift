protocol LocalStorage {
    func writeToDisk(data: NSData, toUrl url: NSURL)
}

struct DiskStorage: LocalStorage {
    func writeToDisk(data: NSData, toUrl url: NSURL) {
        data.writeToURL(url, atomically: true)
    }
}