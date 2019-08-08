import CoreData

class DeliveriesStorageManager {

    let persistentContainer: NSPersistentContainer!

    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()

    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    convenience init() {
        guard let appDelegate = AppDelegate.shared else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }

    func getSavedDeliveries() -> DeliveryViewModels {
        guard Defaults.canCache() else {
            return []
        }
        var savedDeliveries = DeliveryViewModels()
        let context = backgroundContext
        let deliveriesFetch: NSFetchRequest<DeliveryEntity> = DeliveryEntity.fetchRequest()
            do {
                let fetchedDeliveries = try context.fetch(deliveriesFetch)
                for deliveryEntity in fetchedDeliveries {
                    let location = Location(lat: deliveryEntity.deliveryLocation?.latitude, lng: deliveryEntity.deliveryLocation?.longitude, address: deliveryEntity.deliveryLocation?.address)
                    let delivery = Delivery(id: Int(deliveryEntity.id), deliveryDescription: deliveryEntity.deliveryDescription, imageURL: deliveryEntity.imageUrl, location: location)
                    savedDeliveries.append(DeliveryCellViewModel(delivery: delivery))
                }
            } catch {
                print("Failed to fetch deliveries: \(error)")
            }
        return savedDeliveries
    }

    func saveDeliveries(deliveries: Deliveries?) {
        guard Defaults.canCache() else {
            return
        }

        func saveLocation(location: Location, context: NSManagedObjectContext) -> LocationEntity? {
            if let locationEntity = NSEntityDescription.insertNewObject(forEntityName:
                String(describing: LocationEntity.self), into: context) as? LocationEntity {
                locationEntity.latitude = location.lat ?? 0
                locationEntity.longitude = location.lng ?? 0
                locationEntity.address = location.address
                return locationEntity
            }
            return nil
        }

        if let deliveriesToSave = deliveries {
            let context = backgroundContext
            for delivery in deliveriesToSave {
                if let deliveryEntity = NSEntityDescription.insertNewObject(forEntityName:
                    String(describing: DeliveryEntity.self), into: context) as? DeliveryEntity {
                    deliveryEntity.id = Int16(delivery.id ?? 0)
                    deliveryEntity.deliveryDescription = delivery.deliveryDescription
                    deliveryEntity.imageUrl = delivery.imageURL
                    if let deliveryLocation = delivery.location {
                        deliveryEntity.deliveryLocation = saveLocation(location: deliveryLocation, context: context)
                    }
                }
            }
            do {
                try context.save()
            } catch {
                print("Failed to save deliveries: \(error)")
            }
        }
    }

    func deleteAllDeliveries() {
        if persistentContainer.persistentStoreDescriptions.first?.type != NSInMemoryStoreType {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DeliveryEntity.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? backgroundContext.execute(deleteRequest)
        }
    }
}
