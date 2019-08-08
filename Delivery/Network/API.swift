import Foundation
import Moya
import Alamofire

// MARK: - Provider support
let baseUrl = "https://mock-api-mobile.dev.lalamove.com/"

public enum API {
    case GETDELIVERIES(offset: Int, limit: Int)
}

extension API: TargetType {
    public var task: Task {
        switch self {
        case .GETDELIVERIES(let params):
            return .requestParameters(parameters: ["offset": params.offset, "limit": params.limit], encoding: URLEncoding.default)
        }
    }

    public var headers: [String: String]? {
        return [:]
    }

    public var baseURL: URL { return URL(string: baseUrl)! }

    public var path: String {
        switch self {
        case .GETDELIVERIES:
            return "deliveries"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }

    public var validate: Bool {
        switch self {
        default:
            return true
        }
    }

    public var sampleData: Data {
        return Data()
    }
}
