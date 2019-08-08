import UIKit
import MapKit

class DeliveryDetailsViewController: UIViewController {

    var viewModel: DeliveryDetailsViewModel?
    let mapSpanSize: CLLocationDistance = 500
    let detailsFooterViewMargin = 8

    lazy var mapView: MKMapView = {
        let view = MKMapView()
        if let centerCordinate = self.viewModel?.coordinates {
            let annotation = MKPointAnnotation()
            let centerCoordinate = centerCordinate
            let viewRegion = MKCoordinateRegion(center: centerCordinate, latitudinalMeters: mapSpanSize, longitudinalMeters: mapSpanSize)
            annotation.coordinate = centerCordinate
            annotation.title = self.viewModel?.details
            view.setRegion(viewRegion, animated: true)
            view.addAnnotation(annotation)
        }
        return view
    }()

    lazy var detailsFooterView: UIView = {
        let view = DeliveryCell()
        view.contentView.backgroundColor = .white
        view.deliveryViewModel = self.viewModel
        return view.contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedStrings.deliveryDetails
        self.view.addSubview(mapView)
        self.view.addSubview(detailsFooterView)
        mapView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(view)
            make.center.equalTo(view)
        }
        detailsFooterView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(detailsFooterViewMargin)
            make.bottom.equalTo(view).offset(-(4 * detailsFooterViewMargin))
            make.right.equalTo(view).offset(-detailsFooterViewMargin)
            make.height.greaterThanOrEqualTo(DeliveryCell.cellHeight)
        }
    }
}
