import XCTest
import Moya
import CoreData
@testable import Delivery

class DeliveryListViewModelTests: XCTestCase {

    var viewModel: DeliveryListViewModel!
    let delivery = Delivery(id: 0, deliveryDescription: "desc", imageURL: "imageURL", location: Location(lat: 0, lng: 0, address: "address"))

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let provider = MoyaProvider<API>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        viewModel = DeliveryListViewModel(provider: provider, storageManager: DeliveriesStorageManager(container: mockPersistantContainer))
    }

    func testGetDeliveries() {
        self.viewModel.getDeliveries()
        XCTAssertTrue(self.viewModel.deliveries.count == 10)
    }

    func testFetchNextPage() {
        let deliveriesCount = viewModel.deliveries.count
        self.viewModel.fetchNextPage()
        XCTAssertTrue(self.viewModel.deliveries.count == (deliveriesCount + 10))
        XCTAssertTrue(self.viewModel.offset == deliveriesCount)
    }

    func testRefreshPage() {
        self.viewModel.refreshPage()
        XCTAssertTrue(self.viewModel.deliveries.count == 10)
        XCTAssertTrue(self.viewModel.offset == 0)
    }

    override func tearDown() {
        viewModel = nil
    }

    func customEndpointClosure(_ target: API) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.testSampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
}
