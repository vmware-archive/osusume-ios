struct DefaultReloader: Reloader {
    func reload(reloadable: Reloadable) {
        reloadable.reloadData()
    }
}