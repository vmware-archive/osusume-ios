protocol Reloader {
    func reload(reloadable: Reloadable)
    func reloadSection(section: Int, reloadable: Reloadable)
}