

import RxSwift
import RxTest

public func onNext<T>(expect element: T) -> RxTest.Recorded<RxSwift.Event<T>> {
    return next(0, element)
}

public func completed<T>(_ type: T.Type = T.self) -> RxTest.Recorded<RxSwift.Event<T>> {
    return completed(0)
}

public func == <T>(lhs: [RxTest.Recorded<RxSwift.Event<T>>], rhs: [RxTest.Recorded<RxSwift.Event<T>>]) -> Bool where T: Equatable {
    var isEqual = true
    guard lhs.count == rhs.count else { return false }
    for index in 0 ..< lhs.count {
        if !(lhs[index] == rhs[index]) {
            isEqual = false
            break
        }
    }
    return isEqual
}
