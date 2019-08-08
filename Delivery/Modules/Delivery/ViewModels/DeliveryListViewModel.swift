import Foundation
import Alamofire
import Moya

typealias DeliveryViewModels = [DeliveryCellViewModel]
typealias DeliveriesFetcher = APIClient<Deliveries>

class DeliveryListViewModel: NSObject {

    static let pageSize = 20
    var onErrorMessage: ((String) -> Void)?
    var onNewData: ((DeliveryViewModels?) -> Void)?
    var onLoading: ((LoaderType) -> Void)?
    var hasMore = true

    private(set) var offset = 0 {
        didSet {
            fetchDeliveries()
        }
    }

    private(set) var deliveries = DeliveryViewModels() {
        didSet {
            onNewData?(deliveries)
        }
    }

    private(set) var loaderType: LoaderType = .center(false) {
        didSet {
            onLoading?(loaderType)
        }
    }

    let apiProvider: MoyaProvider<API>
    let storageManager: DeliveriesStorageManager

    init(provider: MoyaProvider<API> = APIProvider, storageManager: DeliveriesStorageManager = DeliveriesStorageManager()) {
        self.apiProvider = provider
        self.storageManager = storageManager
        self.deliveries = storageManager.getSavedDeliveries()
        super.init()
    }

    private func fetchDeliveries() {
        let shouldAppend = offset > 0
        let request = API.GETDELIVERIES(offset: offset, limit: DeliveryListViewModel.pageSize)
        DeliveriesFetcher.request(provider: apiProvider, apiRequest: request) { [weak self] (result) in
            switch result {
            case .success(let deliveries):
                let deliveryViewModels = deliveries.compactMap({ DeliveryCellViewModel(delivery: $0) })
                self?.hasMore = deliveries.count >= DeliveryListViewModel.pageSize
                if shouldAppend {
                    self?.deliveries += deliveryViewModels
                } else {
                    self?.deliveries = deliveryViewModels
                    self?.storageManager.deleteAllDeliveries()
                }
                self?.storageManager.saveDeliveries(deliveries: deliveries)
            case .failure(let error):
                self?.onErrorMessage?(error.localizedDescription)
            }
            self?.loaderType.toggleVisibility()
        }
    }

    func getDeliveries() {
        if !loaderType.isLoading() {
            loaderType = .center(true)
            offset = 0
        }
    }

    @objc func refreshPage() {
        if !loaderType.isLoading() {
            loaderType = .header(true)
            offset = 0
        }
    }

    func fetchNextPage() {
        if !loaderType.isLoading() && hasMore {
            loaderType = .footer(true)
            offset = deliveries.count
        }
    }
}
