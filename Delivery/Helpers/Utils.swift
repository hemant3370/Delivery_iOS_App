import Foundation

func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}
