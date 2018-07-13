

import Foundation

final class InfrastructureHandler {
    
    func verifyStatusCode(_ response: HTTPURLResponse) throws {
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            let serviceError = getError(from: response.statusCode)
            throw serviceError
        }
    }
    
    private func getError(from statusCode: Int) -> ServiceError {
        switch statusCode {
        case 400...513:
            let restError = RESTError(code: statusCode)
            return .rest(restError)
        default:
            return .internalServerError
        }
    }
}
