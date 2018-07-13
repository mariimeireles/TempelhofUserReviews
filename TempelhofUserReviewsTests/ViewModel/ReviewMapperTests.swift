

@testable import TempelhofUserReviews
import Nimble
import XCTest

final class ReviewMapperTests: XCTestCase {
    
    private var reviewMapper: ReviewMapper!
    
    override func setUp() {
        super.setUp()
        reviewMapper = ReviewMapper()
    }
    
    override func tearDown() {
        reviewMapper = nil
        super.tearDown()
    }
    
    func test_successMapping() {
        let data = [UserReview.DataDetails(rating: "4.0", title: "", message: "viele interessante Informationen und Fakten wurden vermittelt inkl. vieler Details. Leider war der Außenbereich aufgrund einer Veranstaltung nicht zugänglich (was sich aber nicht im Preis niederschlug).\nEs wäre gut, wenn man ein Handout/Skizze/Flyer mit einer kurzen Zusammenfassung der wesentlichen Fakten und Informationen zum Nachlesen zum Abschluss bekommen würde (wäre auch durch den Preis gerechtfertigt).", author: "Sylvia – Germany", date: "July 12, 2018"),
                    UserReview.DataDetails(rating: "4.0", title: "Stunning", message: "", author: "Franca – Italy", date: "July 12, 2018")]
        let userReview = UserReview(data: data)

        do {
            let reviewScreenState = try reviewMapper.mapReviewsRequestToSuccessState(userReview)
            print(reviewScreenState)
            switch reviewScreenState {
            case .success(let data):
                if let data = data.first {
                    expect(data.title).to(equal(""))
                }
            default:
                fail("Wrong mapping")
            }
        } catch {
            fail()
        }
    }
    
    func test_errorMapping() {
        let error = ServiceError.internalServerError
        do {
            let reviewScreenState = reviewMapper.mapErrorToScreenState(error)
            switch reviewScreenState {
            case .failure: break
            default:
                fail("Wrong mapping")
            }
        }
    }
}
