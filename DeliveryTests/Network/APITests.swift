import XCTest
import Moya
@testable import Delivery

class APITests: XCTestCase {

    var provider: MoyaProvider<API>?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        provider = MoyaProvider<API>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        provider = nil
    }

    func testGetDeliveriesAPI() {
        provider?.request(API.GETDELIVERIES(offset: 0, limit: 10), completion: { (result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertNotNil(response.data)
                let deliveries = try? JSONDecoder().decode(Deliveries.self, from: response.data)
                XCTAssertNotNil(deliveries)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        provider?.request(API.GETDELIVERIES(offset: -1, limit: 10), completion: { (result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertNotNil(response.data)
                let deliveries = try? JSONDecoder().decode(Deliveries.self, from: response.data)
                XCTAssertNil(deliveries)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
    }

    func customEndpointClosure(_ target: API) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.testSampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
}

extension API {

    var testSampleData: Data {
        switch self {
        case .GETDELIVERIES(let params):
            let filename = params.offset != -1 ? "deliveries" : "wrongDeliveries"
            guard let url = Bundle(for: APITests.self).url(forResource: filename, withExtension: "json") else { return Data() }
            let mockData = try? Data(contentsOf: url)
            return  mockData ?? Data()
        }
    }
}
