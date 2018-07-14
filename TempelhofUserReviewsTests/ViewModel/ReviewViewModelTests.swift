

import Nimble
import RxSwift
import RxTest
@testable import TempelhofUserReviews
import XCTest

final class ReviewViewModelTests: XCTestCase {
    
    private var disposeBag: DisposeBag!
    private var webServiceMock: UserReviewWebServiceMock!
    private var viewModel: ReviewsViewModel!
    private var mapper: ReviewMapper!
    private let scheduler = TestScheduler(initialClock: 0)
    private var observer: TestableObserver<ReviewScreenState>!
    
    private func setServiceState(for state: UserReviewWebServiceMock.ReviewScreenStateMock = .success) {
        webServiceMock = UserReviewWebServiceMock(desired: state)
        viewModel = ReviewsViewModel(webService: webServiceMock, mapper: mapper)
    }
    
    private func getReviews() {
        viewModel.getReviews()
            .subscribe(observer)
            .disposed(by: disposeBag)
        scheduler.start()
    }
    
    private func compareResult(with expectedResult: [Recorded<Event<ReviewScreenState>>]) -> Bool {
        let getResult = observer.events
        return getResult == expectedResult
    }
    
    private func pipelineState(for state: UserReviewWebServiceMock.ReviewScreenStateMock, expectedState: ReviewScreenState) -> Bool {
        setServiceState(for: state)
        getReviews()
        let expectedResult = [
            onNext(expect: ReviewScreenState.loading),
            onNext(expect: expectedState),
            completed()
        ]
        return compareResult(with: expectedResult)
    }
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        mapper = ReviewMapper()
        observer = scheduler.createObserver(ReviewScreenState.self)
    }
    
    override func tearDown() {
        disposeBag = nil
        mapper = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_initialState_shouldBe_loading() {
        setServiceState()
        getReviews()
        let getState = observer.events.first!
        let expectedState = onNext(expect: ReviewScreenState.loading)
        let equalState = getState == expectedState
        expect(equalState).to(beTrue())
    }
    
    func test_state_shouldBe_successWithNoReviews_withEmptyResult() {
        let isPipelineEqual = pipelineState(for: .successWithNoReviews, expectedState: .successWithNoReviews)
        expect(isPipelineEqual).to(beTrue())
    }
    
    func test_state_shouldBe_failure_withServerError() {
        let isPipelineEqual = pipelineState(for: .serverError, expectedState: .failure(.serverError))
        expect(isPipelineEqual).to(beTrue())
    }
    
    func test_state_shouldBe_failure_withInternalError() {
        let isPipelineEqual = pipelineState(for: .unknown, expectedState: .failure(.unknown))
        expect(isPipelineEqual).to(beTrue())
    }
}

extension ReviewScreenState: Equatable {
    public static func ==(lhs: ReviewScreenState, rhs: ReviewScreenState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.successWithNoReviews, .successWithNoReviews):
            return true
        case let (.failure(error), .failure(error2)):
            return error == error2
        default:
            return false
        }
    }
}
