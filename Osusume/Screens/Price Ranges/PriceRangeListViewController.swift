import Foundation
import Result
import BrightFutures
import PureLayout

class PriceRangeListViewController: UIViewController {
    private let priceRangeRepo: PriceRangeRepo
    private let reloader: Reloader

    private var priceRanges: [PriceRange]

    let tableView: UITableView

    init(
        priceRangeRepo: PriceRangeRepo,
        reloader: Reloader
    ) {
        self.priceRangeRepo = priceRangeRepo
        self.reloader = reloader

        self.priceRanges = []

        self.tableView = UITableView.newAutoLayoutView()
        super.init(nibName: nil, bundle: nil)

        self.tableView.registerClass(
            UITableViewCell.self,
            forCellReuseIdentifier: "PriceRangeCell"
        )
        self.tableView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Price Range"

        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()

        priceRangeRepo.getAll()
            .onSuccess { priceRanges in
                self.priceRanges = priceRanges
                self.reloader.reload(self.tableView)
            }
    }
}

extension PriceRangeListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceRanges.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("PriceRangeCell")!

        cell.textLabel?.text = priceRanges[indexPath.row].range

        return cell
    }
}
