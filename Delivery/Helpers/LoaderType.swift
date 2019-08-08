import Foundation

enum LoaderType {
    case header(Bool)
    case center(Bool)
    case footer(Bool)

    func isLoading() -> Bool {
        switch self {
        case .center(let visiblity):
            return visiblity
        case .footer(let visiblity):
            return visiblity
        case .header(let visiblity):
            return visiblity
        }
    }

    mutating func toggleVisibility() {
        switch self {
        case .center(let visiblity):
            self = .center(!visiblity)
        case .footer(let visiblity):
            self = .footer(!visiblity)
        case .header(let visiblity):
            self = .header(!visiblity)
        }
    }
}
