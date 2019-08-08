import UIKit
import Toast_Swift
import DZNEmptyDataSet

class DeliveryListViewController: UIViewController {

    lazy var deliveryTableView: UITableView = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = LocalizedStrings.pullToRefresh.attributedString
        refreshControl.addTarget(self.viewModel, action: #selector(self.viewModel.refreshPage), for: .valueChanged)
        let table = UITableView()
        table.estimatedRowHeight = DeliveryCell.cellHeight
        table.rowHeight = UITableView.automaticDimension
        table.delegate = self
        table.dataSource = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        table.accessibilityLabel = DeliveryListViewController.deliveryTableViewIdentifier
        table.accessibilityIdentifier = DeliveryListViewController.deliveryTableViewIdentifier
        table.tableFooterView = UIView()
        table.register(DeliveryCell.self, forCellReuseIdentifier: DeliveryCell.reuseIdentifier)
        table.refreshControl = refreshControl
        return table
    }()

    lazy var loadingFooter: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .whiteLarge)
        loader.color = .black
        loader.startAnimating()
        return loader
    }()

    var viewModel = DeliveryListViewModel()
    let router = DeliveryListRouter()
    static let deliveryTableViewIdentifier = "DeliveryListTableView"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedStrings.thingsToDeliver
        self.view.addSubview(deliveryTableView)
        deliveryTableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
            make.center.equalTo(self.view)
        }
        setupBindings()
        if viewModel.deliveries.count == 0 {
            viewModel.getDeliveries()
        }
    }

    func setupBindings() {
        viewModel.onLoading = { [weak self] (loader) in
            switch loader {
            case .header(let show):
                show ? self?.deliveryTableView.refreshControl?.beginRefreshing() : self?.deliveryTableView.refreshControl?.endRefreshing()
            case .center(let show):
                show ? self?.view.makeToastActivity(.center) : self?.view.hideToastActivity()
            case .footer(let show):
                self?.deliveryTableView.tableFooterView =  show ? self?.loadingFooter : UIView()
            }
        }
        viewModel.onErrorMessage = { [weak self] (errorMessage) in
            self?.view.makeToast(errorMessage, duration: 2)
        }
        viewModel.onNewData = { [weak self] (deliveries) in
            self?.deliveryTableView.reloadData()
        }
    }
}

// MARK: - TableView Setup
extension DeliveryListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.deliveries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryCell.reuseIdentifier, for: indexPath)
            as? DeliveryCell {
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let deliveryViewModel = viewModel.deliveries[safe: indexPath.row] {
          (cell as? DeliveryCell)?.deliveryViewModel = deliveryViewModel
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        router.route(to: Route.deliveryDetails.rawValue, from: self, parameters: viewModel.deliveries[safe: indexPath.row])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > 0 && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
                viewModel.fetchNextPage()
        }
    }
}

// MARK: - Empty TableView Setup
extension DeliveryListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return LocalizedStrings.noData.attributedString
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return LocalizedStrings.pullToRefresh.attributedString
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

// MARK: - Routes
extension DeliveryListViewController {
    enum Route: String {
        case deliveryDetails
    }
}
