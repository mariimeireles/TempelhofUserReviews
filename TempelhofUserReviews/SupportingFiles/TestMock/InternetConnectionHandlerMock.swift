

import Foundation

final class InternetConnectionHandlerMock: InternetConnectionHandler {
    
    override func verifyConnection(_ error: Error) throws {
        guard let urlError = error as? URLError.Code else { throw error }
        
        if urlError == .notConnectedToInternet {
            throw ServiceError.connection(.noConnection)
        }
        if urlError == .timedOut {
            throw ServiceError.connection(.timeOut)
        } else {
            throw ServiceError.connection(.other)
        }
    }
}
