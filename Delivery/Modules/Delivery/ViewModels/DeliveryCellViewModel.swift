import Foundation

class DeliveryCellViewModel {

    let delivery: Delivery
    let details: String
    let receiversImageUrl: URL?

    init(delivery: Delivery) {
        self.delivery = delivery
        if let urlString = delivery.imageURL, let imageUrl = URL(string: urlString) {
            self.receiversImageUrl = imageUrl
        } else {
            self.receiversImageUrl = nil
        }
        if let desc = delivery.deliveryDescription, let address = delivery.location?.address {
            details = desc + LocalizedStrings.joinWithAt + address
        } else {
            details = delivery.deliveryDescription ?? ""
        }
    }
}
