struct RealReloader: Reloader {
    func reload(reloadable: Reloadable) {
        reloadable.reloadData()
    }
}