import UIKit

protocol CuisineSelectionProtocol {
    func cuisineSelected(cuisine: Cuisine)
}

class CuisineListViewController: UIViewController {

    let router: Router
    let tableView: UITableView
    let searchBar: UISearchBar
    let cuisineRepo: CuisineRepo
    let textSearch: TextSearch
    let reloader: Reloader
    var cuisineList: [Cuisine]
    var fullCuisineList: [Cuisine]
    var delegate: CuisineSelectionProtocol?

    init(router: Router, cuisineRepo: CuisineRepo, textSearch: TextSearch, reloader: Reloader) {
        self.router = router
        self.cuisineRepo = cuisineRepo
        self.textSearch = textSearch
        self.reloader = reloader
        self.cuisineList = []
        self.fullCuisineList = []
        self.tableView = UITableView.newAutoLayoutView()
        self.searchBar = UISearchBar.newAutoLayoutView()

        super.init(nibName: nil, bundle: nil)

        let cancelButton: UIBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Cancel,
            target: self,
            action: Selector("didTapCancelButton:")
        )
        navigationItem.leftBarButtonItem = cancelButton

        tableView.registerClass(
            UITableViewCell.self,
            forCellReuseIdentifier: "CuisineCell"
        )
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        title = "Find Cuisine"

        view.addSubview(searchBar)
        view.addSubview(tableView)

        searchBar.autoPinEdgeToSuperviewEdge(.Top, withInset: searchBarOffset())
        searchBar.autoPinEdgeToSuperviewEdge(.Left)
        searchBar.autoPinEdgeToSuperviewEdge(.Right)

        tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: searchBar)
        tableView.autoPinEdgeToSuperviewEdge(.Left)
        tableView.autoPinEdgeToSuperviewEdge(.Right)
        tableView.autoPinEdgeToSuperviewEdge(.Bottom)

        cuisineRepo.getAll()
            .onSuccess { [unowned self] cuisineList in
                self.cuisineList = cuisineList
                self.fullCuisineList = cuisineList
                self.reloader.reload(self.tableView)
            }
    }

    private func searchBarOffset() -> CGFloat {
        let navBarHeight = navigationController?
            .navigationBar.bounds.size.height ?? 0.0
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size

        return navBarHeight + min(statusBarSize.width, statusBarSize.height)
    }

    // MARK: - Actions
    func didTapCancelButton(sender: UIBarButtonItem?) {
        router.dismissFindCuisineScreen()
    }
}

extension CuisineListViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredCuisineArray = textSearch.search(
            searchText,
            collection: fullCuisineList
        )
        cuisineList = filteredCuisineArray

        reloader.reload(self.tableView)
    }
}

extension CuisineListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuisineList.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "CuisineCell",
            forIndexPath: indexPath
        )

        cell.textLabel?.text = cuisineList[indexPath.row].name

        return cell
    }
}

extension CuisineListViewController: UITableViewDelegate {
    func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        delegate?.cuisineSelected(cuisineList[indexPath.row])
        router.dismissFindCuisineScreen()
    }
}

