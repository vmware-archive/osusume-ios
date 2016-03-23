import UIKit

protocol CuisineSelectionProtocol {
    func cuisineSelected(cuisine: Cuisine)
}

class CuisineListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    let router: Router
    let tableView: UITableView
    let searchBar: UISearchBar
    let cuisineRepo: CuisineRepo
    let textSearch: TextSearch
    var cuisineList: CuisineList
    var fullCuisineList: CuisineList
    var delegate: CuisineSelectionProtocol?

    init(router: Router, cuisineRepo: CuisineRepo, textSearch: TextSearch) {
        self.router = router
        self.cuisineRepo = cuisineRepo
        self.textSearch = textSearch
        self.cuisineList = CuisineList(cuisines: [])
        self.fullCuisineList = CuisineList(cuisines: [])
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
                self.tableView.reloadData()
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

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredCuisineArray = textSearch.search(
            searchText,
            collection: fullCuisineList.cuisines
        )
        cuisineList = CuisineList(cuisines: filteredCuisineArray)

        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuisineList.cuisines.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "CuisineCell",
            forIndexPath: indexPath
        )

        cell.textLabel?.text = cuisineList.cuisines[indexPath.row].name

        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        delegate?.cuisineSelected(cuisineList.cuisines[indexPath.row])
        router.dismissFindCuisineScreen()
    }
}

