import XCTest
import CoreData
import Moya
@testable import Delivery

class DeliveryListViewControllerTests: XCTestCase {

    var deliveryListVC: DeliveryListViewController?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        deliveryListVC = DeliveryListViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        deliveryListVC = nil
    }

    func testViewControllerElements() {
        XCTAssertNotNil(deliveryListVC)
        XCTAssertNotNil(deliveryListVC?.viewModel)
        XCTAssertNotNil(deliveryListVC?.deliveryTableView)
    }

    func customEndpointClosure(_ target: API) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.testSampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
}
