import XCTest
import Moya
import CoreData
@testable import Delivery

class DeliveryDetailsViewModelTests: XCTestCase {

    var viewModel: DeliveryDetailsViewModel!
    var delivery = Delivery(id: 0, deliveryDescription: "desc", imageURL: "imageURL", location: Location(lat: 0, lng: 0, address: "address"))

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = DeliveryDetailsViewModel(delivery: delivery)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testDeliveryDetails() {
        XCTAssert(delivery == viewModel.delivery)
        XCTAssertNotNil(viewModel.coordinates)
        XCTAssertTrue(viewModel.coordinates.latitude == delivery.location?.lat)
        XCTAssertTrue(viewModel.coordinates.longitude == delivery.location?.lng)
        delivery = Delivery(id: 0, deliveryDescription: "desc", imageURL: "imageURL", location: nil)
        viewModel = DeliveryDetailsViewModel(delivery: delivery)
        XCTAssertNotNil(viewModel.coordinates)
    }
}
