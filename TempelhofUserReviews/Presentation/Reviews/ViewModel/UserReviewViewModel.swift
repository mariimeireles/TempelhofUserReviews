

import RxSwift

final class UserReviewsViewModel {
    
    private let webService: UserReviewWebServiceProtocol
    private let mapper: UserReviewMapper
    
    init(webService: UserReviewWebServiceProtocol, mapper: UserReviewMapper) {
        self.webService = webService
        self.mapper = mapper
    }
    
    func getReviews() -> Observable<UserReviewScreenState> {
        return getScreenState()
            .startWith(.loading)
    }

    private func getScreenState() -> Observable<UserReviewScreenState> {
        return webService.getReviews()
            .map { [unowned self] reviews in
                try self.mapper.mapReviewsRequestToSuccessState(reviews)
            }
            .catchError { [unowned self] (error) -> Observable<UserReviewScreenState> in
                let state = self.mapper.mapErrorToScreenState(error)
                return Observable.just(state)
        }
    }
}
