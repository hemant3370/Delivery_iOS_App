import XCTest
@testable import Delivery

class DeliveryViewModelTests: XCTestCase {

    var viewModel: DeliveryCellViewModel!
    var delivery = Delivery(id: 0, deliveryDescription: "desc", imageURL: "imageUrl", location: Location(lat: 0, lng: 0, address: "address"))

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = DeliveryCellViewModel(delivery: delivery)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testDeliveryDetails() {
        XCTAssertNotNil(viewModel)
        XCTAssert(delivery == viewModel.delivery)
        XCTAssertNotNil(viewModel.details)
        XCTAssertNotNil(viewModel.receiversImageUrl)
        delivery = Delivery(id: nil, deliveryDescription: nil, imageURL: nil, location: nil)
        viewModel = DeliveryCellViewModel(delivery: delivery)
        XCTAssertTrue(viewModel.details == "")
        XCTAssertNil(viewModel.receiversImageUrl)
    }
}

extension Delivery: Equatable {
    public static func == (lhs: Delivery, rhs: Delivery) -> Bool {
        return lhs.id == rhs.id
    }
}
