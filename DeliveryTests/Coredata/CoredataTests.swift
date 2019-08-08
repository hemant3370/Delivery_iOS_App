import XCTest
import CoreData
@testable import Delivery

class CoredataTests: XCTestCase {

    var storageManager: DeliveriesStorageManager!

    lazy var mockdata: Deliveries = {
        var deliveries = Deliveries()
        let url = Bundle(for: CoredataTests.self).url(forResource: "deliveries", withExtension: "json")!
        let mockData = try? Data(contentsOf: url)
        let parsedDeliveries = try? JSONDecoder().decode(Deliveries.self, from: mockData ?? Data())
        deliveries.append(contentsOf: parsedDeliveries ?? Deliveries())
        return deliveries
    }()

    override func setUp() {
        super.setUp()
        storageManager = DeliveriesStorageManager(container: mockPersistantContainer)
        }

    func testSaveAndGet() {
        storageManager.saveDeliveries(deliveries: mockdata)
        XCTAssert(mockdata.count == storageManager.getSavedDeliveries().count)
    }

    override func tearDown() {
        storageManager = nil
    }
}

 var mockPersistantContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Delivery")
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    description.shouldAddStoreAsynchronously = false // Make it simpler in test env
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { (description, error) in
        // Check if the data store is in memory
        precondition( description.type == NSInMemoryStoreType )
        // Check if creating container wrong
        if let error = error {
            fatalError("Create an in-memory coordinator failed \(error)")
        }
    }
    return container
}()
