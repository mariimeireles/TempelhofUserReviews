

final class Injector {
    
    private let arguments: [String]
    private let reviewMapper: ReviewMapper
    
    init(with arguments: [String], reviewMapper: ReviewMapper) {
        self.arguments = arguments
        self.reviewMapper = reviewMapper
    }
    
    func reviewsViewModel() -> ReviewsViewModel {
        return ReviewsViewModel(webService: userReviewWebService(), mapper: self.reviewMapper)
    }
    
    func newReviewViewModel() -> NewReviewViewModel {
        return NewReviewViewModel(webService: newUserReviewWebService(), mapper: self.reviewMapper)
    }
    
    func newUserReviewWebService() -> NewUserReviewWebServiceProtocol {
        return NewUserReviewWebService()
    }
    
    func userReviewWebService() -> UserReviewWebServiceProtocol {
        return UserReviewWebService()
    }
}
