import UIKit

struct DeliveryListRouter: Router {

    func route(to routeID: String, from context: UIViewController, parameters: Any?) {
        guard let route = DeliveryListViewController.Route(rawValue: routeID) else {
            return
        }
        switch route {
        case .deliveryDetails:
            guard let deliveryVM = parameters as? DeliveryCellViewModel else {
                return
            }
            let destinationVC = DeliveryDetailsViewController()
            destinationVC.viewModel = DeliveryDetailsViewModel(delivery: deliveryVM.delivery)
            context.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}
