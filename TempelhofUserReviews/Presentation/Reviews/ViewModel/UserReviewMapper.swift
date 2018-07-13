

import Foundation
import UIKit

final class UserReviewMapper {

    func mapReviewsRequestToSuccessState(_ review: UserReview) throws -> UserReviewScreenState {
        let data = try review.data.map {
            try ReviewModel(review: $0)
        }
        return UserReviewScreenState.success(data)
    }

    func mapErrorToScreenState(_ error: Error) -> UserReviewScreenState {
        guard let serviceError = error as? ServiceError else {
            return UserReviewScreenState.failure(.unknown)
        }
        switch serviceError {
        case let .rest(error):
            return UserReviewScreenState(restError: error)
        case let .connection(error):
            switch error {
            case .noConnection:
                return UserReviewScreenState.failure(.noConnection)
            case .timeOut:
                return UserReviewScreenState.failure(.timeOut)
            default:
                return UserReviewScreenState.failure(.unknown)
            }
        case .internalServerError:
            return UserReviewScreenState.failure(.serverError)
        default:
            return UserReviewScreenState.failure(.unknown)
        }
    }
}
