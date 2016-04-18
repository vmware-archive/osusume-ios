import UIKit

protocol CuisineSelectionProtocol {
    func cuisineSelected(cuisine: Cuisine)
}

class CuisineListViewController: UIViewController {
    private let router: Router
    private let cuisineRepo: CuisineRepo
    private let textSearch: TextSearch
    private let reloader: Reloader
    private(set) var filteredCuisineList: [Cuisine]
    private(set) var fullCuisineList: [Cuisine]
    var cuisineSelectionDelegate: CuisineSelectionProtocol?

    let tableView: UITableView
    let searchBar: UISearchBar

    init(router: Router, cuisineRepo: CuisineRepo, textSearch: TextSearch, reloader: Reloader) {
        self.router = router
        self.cuisineRepo = cuisineRepo
        self.textSearch = textSearch
        self.reloader = reloader
        self.filteredCuisineList = []
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
            forCellReuseIdentifier: "AddCuisineCell"
        )

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
                self.filteredCuisineList = cuisineList
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
        filteredCuisineList = filteredCuisineArray

        reloader.reload(self.tableView)
    }
}

extension CuisineListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        return filteredCuisineList.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let addCuisineCell = UITableViewCell()
            addCuisineCell.userInteractionEnabled = isCurrentSearchTermPartialMatch()
            addCuisineCell.textLabel?.text = "Add Cuisine"

            return addCuisineCell
        }

        let cuisineCell = tableView.dequeueReusableCellWithIdentifier(
            "CuisineCell",
            forIndexPath: indexPath
        )

        cuisineCell.textLabel?.text = filteredCuisineList[indexPath.row].name

        return cuisineCell
    }

    private func isCurrentSearchTermPartialMatch() -> Bool {
        let searchTerm = searchBar.text ?? ""

        guard searchTerm != "" else {
            return false
        }

        let exactSearchMatches = textSearch.exactSearch(searchTerm, collection: filteredCuisineList)
        return exactSearchMatches.isEmpty
    }
}

extension CuisineListViewController: UITableViewDelegate {
    func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == 0 {
            cuisineRepo.create(NewCuisine(name: searchBar.text!))
                .onSuccess { [unowned self] savedCuisine in
                    self.cuisineSelectionDelegate?.cuisineSelected(savedCuisine)
                    self.router.dismissFindCuisineScreen()
                }
        } else {
            cuisineSelectionDelegate?.cuisineSelected(filteredCuisineList[indexPath.row])
            router.dismissFindCuisineScreen()
        }
    }
}

