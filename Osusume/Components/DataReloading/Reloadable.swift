protocol Reloadable {
    func reloadData()
    func reloadSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation)
}
