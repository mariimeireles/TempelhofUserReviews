

import Nimble
@testable import TempelhofUserReviews
import XCTest

final class InternetConnectionHandlerTests: XCTestCase {
    
    private var internetConnectionHandler: InternetConnectionHandler!
    private func verifyConnectionMock(_ error: URLError.Code) throws {
        if error == .notConnectedToInternet {
            throw ServiceError.connection(.noConnection)
        }
        if error == .timedOut {
            throw ServiceError.connection(.timeOut)
        } else {
            throw ServiceError.connection(.other)
        }
    }
    
    private func verifyError(_ error: URLError.Code, equalTo expectedError: InternetConnectionError) {
        expect {
            try self.verifyConnectionMock(error)
        }.to(throwError(closure: { (error: ServiceError) in
            if case let .connection(noConnection) = error {
                expect(noConnection).to(equal(expectedError))
            } else { fail() }
        }))
    }
    
    override func setUp() {
        super.setUp()
        self.internetConnectionHandler = InternetConnectionHandler()
    }
    
    override func tearDown() {
        self.internetConnectionHandler = nil
        super.tearDown()
    }
    
    func test_shouldThrow_notConnectedError_when_hasNoConnection() {
        let notConnected = URLError.notConnectedToInternet
        verifyError(notConnected, equalTo: .noConnection)
    }
    
    func test_shouldThrow_timeOutError_when_timedOut() {
        let timedOut = URLError.timedOut
        verifyError(timedOut, equalTo: .timeOut)
    }
    
    func test_shouldThrow_otherError_when_error() {
        let unknown = URLError.unknown
        verifyError(unknown, equalTo: .other)
    }
}
