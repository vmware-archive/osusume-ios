extension UICollectionView: Reloadable {}

extension UICollectionView {
    public func reloadSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        self.reloadSections(sections)
    }
}

extension UITableView: Reloadable {}