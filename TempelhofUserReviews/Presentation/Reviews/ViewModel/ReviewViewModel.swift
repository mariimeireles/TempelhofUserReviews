

import RxSwift

final class ReviewsViewModel {
    
    private let webService: UserReviewWebServiceProtocol
    private let mapper: ReviewMapper
    
    init(webService: UserReviewWebServiceProtocol, mapper: ReviewMapper) {
        self.webService = webService
        self.mapper = mapper
    }
    
    func getReviews() -> Observable<ReviewScreenState> {
        return getScreenState()
            .startWith(.loading)
    }

    private func getScreenState() -> Observable<ReviewScreenState> {
        return webService.getReviews()
            .map { [unowned self] reviews in
                try self.mapper.mapReviewsRequestToSuccessState(reviews)
            }
            .catchError { [unowned self] (error) -> Observable<ReviewScreenState> in
                let state = self.mapper.mapErrorToScreenState(error)
                return Observable.just(state)
            }
    }
}
