struct DefaultReloader: Reloader {
    func reload(reloadable: Reloadable) {
        reloadable.reloadData()
    }

    func reloadSection(section: Int, reloadable: Reloadable) {
        reloadable.reloadSections(
            NSIndexSet(index: section),
            withRowAnimation: .None
        )
    }
}