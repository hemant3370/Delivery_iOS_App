//
//  APITest.swift
//  DeliveryTests
//
//  Created by Hemant Singh on 26/07/19.
//  Copyright © 2019 Hemant Singh. All rights reserved.
//

import XCTest
import Moya

class APITests: XCTestCase {

    var provider: MoyaProvider<API>!

    override func setUp() {
        super.setUp()

        // A mock provider with a mocking `endpointClosure` that stub immediately
        provider = MoyaProvider<API>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    }
    func testGetDeliveries() {
        let expected = try? JSONDecoder().decode(Deliveries.self, from: API.GETDELIVERIES([:]).testSampleData)
        var response: Deliveries?
        provider.request(.GETDELIVERIES([:])) { (result) in
            switch result {
            case .success(let res):
                response = try? JSONDecoder().decode(Deliveries.self, from: res.data)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        XCTAssert(response == expected)
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
        case .GETDELIVERIES:
            // Returning deliveries.json
            let url = Bundle(for: APITests.self).url(forResource: "deliveries", withExtension: "json")!
            let mockData = try? Data(contentsOf: url)
            return  mockData ?? Data()
        }
    }
}
