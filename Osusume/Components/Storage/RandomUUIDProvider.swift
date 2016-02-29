protocol UUIDProvider {
    func uuidKey() -> String
}

struct RandomUUIDProvider: UUIDProvider {
    func uuidKey() -> String {
        return NSUUID().UUIDString
    }
}
