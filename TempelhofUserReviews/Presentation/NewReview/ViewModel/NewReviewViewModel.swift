

import RxSwift

final class NewReviewViewModel {

    private let webService: NewUserReviewWebServiceProtocol
    private let mapper: ReviewMapper

    init(webService: NewUserReviewWebServiceProtocol, mapper: ReviewMapper) {
        self.webService = webService
        self.mapper = mapper
    }

    func postNewReview(with rating: Int, title: String, message: String) -> Observable<ReviewScreenState> {
        return self.getScreenStateFrom(rating: rating, title: title, message: message)
            .startWith(.loading)
    }

    private func getScreenStateFrom(rating: Int, title: String, message: String) -> Observable<ReviewScreenState> {
        guard let newReview = try? mapper.mapInputsToNewUserReview(rating: rating, title: title, message: message) else { return Observable.just(ReviewScreenState.failure(.unknown)) }
        return self.webService.postLoginInfo(newReview)
            .map { [unowned self] reviews in
                try self.mapper.mapReviewsRequestToSuccessState(reviews)
            }
            .catchError { [unowned self] (error) -> Observable<ReviewScreenState> in
                let state = self.mapper.mapErrorToScreenState(error)
                return Observable.just(state)
            }
    }
}
