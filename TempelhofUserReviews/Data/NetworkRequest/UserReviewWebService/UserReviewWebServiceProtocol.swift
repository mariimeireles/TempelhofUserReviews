

import RxSwift

protocol UserReviewWebServiceProtocol: AnyObject {
    
    func getReviews() -> Observable<UserReview>
}
