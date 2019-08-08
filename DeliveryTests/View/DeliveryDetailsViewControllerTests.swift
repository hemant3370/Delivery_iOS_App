import XCTest
@testable import Delivery

class DeliveryDetailsViewControllerTests: XCTestCase {

    var deliveryDetailsVC: DeliveryDetailsViewController?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        deliveryDetailsVC = DeliveryDetailsViewController()
        let delivery = Delivery(id: 0, deliveryDescription: "desc", imageURL: "imageURL", location: Location(lat: 0, lng: 0, address: "address"))
        deliveryDetailsVC?.viewModel = DeliveryDetailsViewModel(delivery: delivery)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        deliveryDetailsVC = nil
    }

    func testViewControllerElements() {
        XCTAssertNotNil(deliveryDetailsVC)
        XCTAssertNotNil(deliveryDetailsVC?.viewModel)
        XCTAssertNotNil(deliveryDetailsVC?.mapView)
        XCTAssertNotNil(deliveryDetailsVC?.detailsFooterView)
    }
}
