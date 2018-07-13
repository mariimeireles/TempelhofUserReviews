

import UIKit

protocol Identifying {}

extension Identifying where Self: NSObject {
    static var identifier: String { return String(describing: self) }
}

extension NSObject: Identifying {}
