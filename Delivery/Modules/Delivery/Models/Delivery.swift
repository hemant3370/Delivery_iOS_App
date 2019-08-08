import Foundation

typealias Deliveries = [Delivery]

struct Delivery: Codable {
    let id: Int?
    let deliveryDescription: String?
    let imageURL: String?
    let location: Location?

    enum CodingKeys: String, CodingKey {
        case id
        case deliveryDescription = "description"
        case imageURL = "imageUrl"
        case location
    }
}
