

import RxSwift

protocol NewUserReviewWebServiceProtocol: AnyObject {

    func postLoginInfo(_ newReview: NewUserReview) -> Observable<UserReview>
}
