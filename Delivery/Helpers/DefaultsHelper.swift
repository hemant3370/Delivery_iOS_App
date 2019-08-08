import Foundation

struct Defaults {

    static let canCacheKey = "CAN_CACHE"

    static func canCache() -> Bool {
        return UserDefaults.standard.bool(forKey: Defaults.canCacheKey)
    }

    static func setCanCache(can value: Bool) {
        UserDefaults.standard.set(value, forKey: Defaults.canCacheKey)
        UserDefaults.standard.synchronize()
    }
}
