

import Foundation
import UIKit

final class ReviewMapper {

    func mapReviewsRequestToSuccessState(_ review: UserReview) throws -> ReviewScreenState {
        let data = try review.data.map {
            try ReviewModel(review: $0)
        }
//        if data.isEmpty {
//            return ReviewScreenState.successWithNoReviews
//        }
        return ReviewScreenState.success(data)
    }

    func mapErrorToScreenState(_ error: Error) -> ReviewScreenState {
        guard let serviceError = error as? ServiceError else {
            return ReviewScreenState.failure(.unknown)
        }
        switch serviceError {
        case let .rest(error):
            return ReviewScreenState(restError: error)
        case let .connection(error):
            switch error {
            case .noConnection:
                return ReviewScreenState.failure(.noConnection)
            case .timeOut:
                return ReviewScreenState.failure(.timeOut)
            default:
                return ReviewScreenState.failure(.unknown)
            }
        case .internalServerError:
            return ReviewScreenState.failure(.serverError)
        default:
            return ReviewScreenState.failure(.unknown)
        }
    }
}
