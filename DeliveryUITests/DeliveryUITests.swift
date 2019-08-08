import XCTest

class DeliveryUITests: XCTestCase {

    func testScreenshots() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        snapshot("01DeliveryList", waitForLoadingIndicator: true)
        app.tables["DeliveryListTableView"].cells.element(boundBy: 0).tap()
        snapshot("02DeliveryDetails", timeWaitingForIdle: 3)
    }
}
