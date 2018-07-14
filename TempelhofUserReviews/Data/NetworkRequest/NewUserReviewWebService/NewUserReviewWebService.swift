

import Alamofire
import RxAlamofire
import RxSwift

final class NewUserReviewWebService: NewUserReviewWebServiceProtocol {
    
    private let postUrl = "https://private-ade97-tempelhofuserreviews.apiary-mock.com/reviews"
    
    func postLoginInfo(_ newReview: NewUserReview) -> Observable<UserReview> {
        let decoder = JSONDecoder()
        let infraHandler = InfrastructureHandler()
        let internetHandler = InternetConnectionHandler()
        let json: JSON
        
        do {
            json = try convertReviewToJSON(newReview)
        } catch {
            return Observable.error(error)
        }
        let postHeader = ["Content-Type": "application/json"]
        
        return RxAlamofire.requestJSON(.post, self.postUrl, parameters: json, encoding: JSONEncoding.default, headers: postHeader)
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
    
    private func convertReviewToJSON(_ review: NewUserReview) throws -> JSON {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(review)
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON else { throw ServiceError.jsonParse }
            return json
        } catch {
            throw ServiceError.jsonParse
        }
    }
}
