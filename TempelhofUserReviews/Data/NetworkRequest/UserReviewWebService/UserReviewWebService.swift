

import Alamofire
import Foundation
import RxAlamofire
import RxSwift

final class UserReviewWebService: UserReviewWebServiceProtocol {
    
    private let getUrl = "https://www.getyourguide.com/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/reviews.json?count=5&page=0&rating=0&sortBy=date_of_review&direction=DESC"
    
    func getReviews() -> Observable<UserReview> {
        let decoder = JSONDecoder()
        let infraHandler = InfrastructureHandler()
        let internetHandler = InternetConnectionHandler()
        
        return RxAlamofire.requestJSON(.get, getUrl)
            .do(onNext: { response, _ in
                try infraHandler.verifyStatusCode(response)
            })
            .do(onError: { error in
                try internetHandler.verifyConnection(error)
            })
            .map({ (_, result) -> UserReview in
                guard let data = try? JSONSerialization.data(withJSONObject: result, options: []) else { throw ServiceError.jsonParse }
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(UserReview.self, from: data)
            })
    }
}
