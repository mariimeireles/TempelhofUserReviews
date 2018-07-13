

enum UserReviewScreenState {
    case loading
    case success([ReviewModel])
    case failure(UserReviewScreenErrorType)

    init(restError: RESTError) {
        switch restError {
        case .serverError:
            self = .failure(.serverError)
        default:
            self = .failure(.unknown)
        }
    }
}
