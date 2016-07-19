import BrightFutures
import XCTest
import Nimble
@testable import Osusume

class PriceRangeListViewControllerTest: XCTestCase {
    let fakeReloader = FakeReloader()
    let fakeRouter = FakeRouter()
    var fakePriceRangeRepo = FakePriceRangeRepo()
    var fakePriceRangeSelectionDelegate = FakePriceRangeSelectionDelegate()
    var priceRangeListVC: PriceRangeListViewController!
    var returnPriceRangeListPromise: Promise<[PriceRange], RepoError>!

    override func setUp() {
        super.setUp()

        returnPriceRangeListPromise = Promise<[PriceRange], RepoError>()
        fakePriceRangeRepo.getAll_returnValue = returnPriceRangeListPromise.future

        priceRangeListVC = PriceRangeListViewController(
            priceRangeRepo: fakePriceRangeRepo,
            reloader: fakeReloader,
            router: fakeRouter,
            priceRangeSelection: fakePriceRangeSelectionDelegate
        )
        priceRangeListVC.view.setNeedsLayout()
    }

    // MARK: - View Controller Lifecycle
    func test_viewDidLoad_setsTitle() {
        expect(self.priceRangeListVC.title).to(equal("Select Price Range"))
    }

    func test_viewDidLoad_registersCellClass() {
        let cell: UITableViewCell? = priceRangeListVC.tableView.dequeueReusableCellWithIdentifier(String(UITableViewCell))

        expect(cell).toNot(beNil())
    }

    func test_viewDidLoad_callsGetAllOnPriceRangeRepo() {
        expect(self.fakePriceRangeRepo.getAll_wasCalled).to(beTrue())
    }

    func test_viewDidLoad_setsDataSourceForTableView() {
        let actualDataSource = self.priceRangeListVC.tableView.dataSource
        expect(actualDataSource) === self.priceRangeListVC
    }

    func test_retrievalOfPriceRangeData_reloadsTableView() {
        returnPriceRangeListPromise.success([])
        waitForFutureToComplete(returnPriceRangeListPromise.future)


        expect(self.fakeReloader.reload_wasCalled).to(beTrue())
    }

    func test_viewDidLoad_showsTableWithOneSection() {
        let tableView = priceRangeListVC.tableView
        let actualNumberOfSections = priceRangeListVC.numberOfSectionsInTableView(tableView)
        expect(actualNumberOfSections).to(equal(1))
    }

    func test_getAllOfPriceRangeData_fillsTableWithAppropriateNumberOfRows() {
        let priceRangeList = [
            PriceRange(id: 1, range: "price-range-1"),
            PriceRange(id: 2, range: "price-range-2")
        ]


        returnPriceRangeListPromise.success(priceRangeList)
        waitForFutureToComplete(returnPriceRangeListPromise.future)


        let tableView = priceRangeListVC.tableView
        let actualNumberOfRows = priceRangeListVC.tableView(
            tableView,
            numberOfRowsInSection: 0
        )
        expect(actualNumberOfRows).to(equal(2))
    }

    func test_getAllOfPriceData_showsCellsContainingPriceData() {
        let priceRangeList = [
            PriceRange(id: 1, range: "price-range-1")
        ]


        returnPriceRangeListPromise.success(priceRangeList)
        waitForFutureToComplete(returnPriceRangeListPromise.future)


        let tableView = priceRangeListVC.tableView
        let cell = priceRangeListVC.tableView(
            tableView,
            cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )
        expect(cell.textLabel?.text).to(equal("price-range-1"))
    }

    func test_tappingPriceRangeCell_passesSelectedPriceRangeToDelegate() {
        let priceRangeList = [PriceRange(id: 0, range: "0~999")]
        returnPriceRangeListPromise.success(priceRangeList)
        waitForFutureToComplete(returnPriceRangeListPromise.future)


        priceRangeListVC.tableView(
            priceRangeListVC.tableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        expect(self.fakePriceRangeSelectionDelegate.priceRangeSelected_arg)
            .to(equal(priceRangeList[0]))
    }

    func test_tappingPriceRangeCell_popsViewControllerOffStack() {
        let priceRangeList = [PriceRange(id: 0, range: "0~999")]
        returnPriceRangeListPromise.success(priceRangeList)
        waitForFutureToComplete(returnPriceRangeListPromise.future)


        priceRangeListVC.tableView(
            priceRangeListVC.tableView,
            didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)
        )


        expect(self.fakeRouter.popViewControllerOffStack_wasCalled).to(beTrue())
    }
}
