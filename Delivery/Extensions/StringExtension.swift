import UIKit

extension String {

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    var attributedString: NSAttributedString {
        return NSAttributedString(string: self)
    }
}
