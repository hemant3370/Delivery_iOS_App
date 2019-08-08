import UIKit
import CoreLocation

class DeliveryDetailsViewModel: DeliveryCellViewModel {

    let coordinates: CLLocationCoordinate2D

    override init(delivery: Delivery) {
        if let latitude = delivery.location?.lat, let longitude = delivery.location?.lng {
            coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            coordinates = CLLocationCoordinate2D()
        }
        super.init(delivery: delivery)
    }
}
