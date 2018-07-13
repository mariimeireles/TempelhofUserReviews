

enum ReviewScreenState {
    case loading
    case success([ReviewModel])
    case successWithNoReviews
    case failure(ReviewScreenErrorType)

    init(restError: RESTError) {
        switch restError {
        case .serverError:
            self = .failure(.serverError)
        default:
            self = .failure(.unknown)
        }
    }
}
