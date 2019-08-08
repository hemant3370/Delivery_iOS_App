import UIKit

protocol Router {
    func route(
        to routeID: String,
        from context: UIViewController,
        parameters: Any?
    )
}
