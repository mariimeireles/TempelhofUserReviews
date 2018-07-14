

import Foundation

class InternetConnectionHandler {

    func verifyConnection(_ error: Error) throws {
        guard let urlError = error as? URLError else { throw error }

        if urlError.code == .notConnectedToInternet {
            throw ServiceError.connection(.noConnection)
        }
        if urlError.code == .timedOut {
            throw ServiceError.connection(.timeOut)
        } else {
            throw ServiceError.connection(.other)
        }
    }
}
