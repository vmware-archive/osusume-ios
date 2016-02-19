protocol UUIDProvider {
    func uuidKey() -> String
}

struct NSUUIDProvider: UUIDProvider {
    func uuidKey() -> String {
        return NSUUID().UUIDString
    }
}
