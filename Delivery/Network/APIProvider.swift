import Alamofire
import Moya

// MARK: - Provider setup

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let configuration = { () -> URLSessionConfiguration in
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    config.requestCachePolicy = .useProtocolCachePolicy
    return config
}()

let networkActivityPlugin = NetworkActivityPlugin { (type, _) in
    switch type {
    case .began:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    case .ended:
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

let plugins = { () -> [PluginType] in
    var plugin: [PluginType] = [networkActivityPlugin]
    #if DEBUG
    plugin.append(NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter))
    #endif
    return plugin
}

let manager = Manager(configuration: configuration)

let APIProvider = MoyaProvider<API>(manager: manager, plugins: plugins())
