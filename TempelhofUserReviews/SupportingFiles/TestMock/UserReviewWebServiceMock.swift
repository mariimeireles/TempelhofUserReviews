

import Foundation
import RxSwift

final class UserReviewWebServiceMock: UserReviewWebServiceProtocol {
    
    private var response = HTTPURLResponse()
    private var userReview: UserReview!
    private var result: JSON = JSON()
    private var isConnectionError = false
    
    init(desired state: ReviewScreenStateMock = .unknown) {
        configMock(to: state)
    }
    
    private func configMock(to state: ReviewScreenStateMock) {
        isConnectionError = false
        switch state {
        case .success:
            userReview = someReviews
            result = someResults
            setResponseForStatus(code: 200)
        case .successWithNoReviews:
            result = emptyResult
            setResponseForStatus(code: 200)
        case .noConnection:
            isConnectionError = true
        case .serverError:
            setResponseForStatus(code: 500)
        case .unknown:
            setResponseForStatus(code: 400)
        }
    }
    
    func getReviews() -> Observable<UserReview> {
        let decoder = JSONDecoder()
        let infraHandler = InfrastructureHandler()
        let internetHandler = InternetConnectionHandlerMock()
        
        return Observable.just((response, result))
            .do(onNext: { response, _ in
                try infraHandler.verifyStatusCode(response)
            })
            .do(onError: { [unowned self] error in
                let error = self.verifyIsInternetError(error)
                try internetHandler.verifyConnection(error)
            })
            .map({ (_, result) -> UserReview in
                let data = try JSONSerialization.data(withJSONObject: result, options: [])
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(UserReview.self, from: data)
            })
    }
    
    private var someReviews: UserReview {
        return UserReview(data: someData)
    }
    
    private var someData: [UserReview.DataDetails] {
        return [
            UserReview.DataDetails(rating: "4.0", title: "", message: "viele interessante Informationen und Fakten wurden vermittelt inkl. vieler Details. Leider war der Außenbereich aufgrund einer Veranstaltung nicht zugänglich (was sich aber nicht im Preis niederschlug).\nEs wäre gut, wenn man ein Handout/Skizze/Flyer mit einer kurzen Zusammenfassung der wesentlichen Fakten und Informationen zum Nachlesen zum Abschluss bekommen würde (wäre auch durch den Preis gerechtfertigt).", author: "Sylvia – Germany", date: "July 12, 2018"),
            UserReview.DataDetails(rating: "4.0", title: "Stunning", message: "", author: "Franca – Italy", date: "July 12, 2018"),
            UserReview.DataDetails(rating: "3.0", title: "Insgesamt leider enttäuschend", message: "In einer Gruppe von über 30 Personen hat uns diese Führung wie wir finden nur oberflächlich zu den interessanten Stationen dieses Objektes geführt.\nEine Beschilderung vor Ort wäre an der Strasse förderlich und nicht erst direkt am Treffpunkt.\nAuch sollte man Interessierte vorab darüber informieren das die Führung über zwei Treppenhäuser mit je 8 und 5 Stockwerke führt, wir waren gut gerüstet aber nicht jedermann ist dafür geeignet!", author: "Jörg – Germany", date: "July 11, 2018")
        ]
    }
    
    private var someResults: JSON {
        return [
            "data": [
                [
                    "review_id": 3030630,
                    "rating": "4.0",
                    "title": ""
                    
                ],
                [
                    "review_id": 3027438,
                    "rating": "4.0",
                    "title": "Stunning"
                ]
            ]
        ]
    }
    
    private var emptyResult: JSON {
        return [
            "data": []
        ]
    }
    
    private func setResponseForStatus(code: Int) {
        let url = URL(string: "https://www.google.com.br")!
        response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
    
    private func verifyIsInternetError(_ error: Error) -> Error {
        if self.isConnectionError {
            return URLError.notConnectedToInternet
        } else {
            return error
        }
    }
    
    enum ReviewScreenStateMock: String {
        case success
        case successWithNoReviews
        case noConnection
        case serverError
        case unknown
        
        init(state: String) {
            switch state {
            case ReviewScreenStateMock.success.rawValue:
                self = .success
            case ReviewScreenStateMock.successWithNoReviews.rawValue:
                self = .successWithNoReviews
            case ReviewScreenStateMock.noConnection.rawValue:
                self = .noConnection
            case ReviewScreenStateMock.serverError.rawValue:
                self = .serverError
            default:
                self = .unknown
            }
        }
    }
}
