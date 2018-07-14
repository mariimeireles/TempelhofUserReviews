

import Nimble
@testable import TempelhofUserReviews
import XCTest

final class InfrastructureHandlerTests: XCTestCase {
    
    private var infrastructureHandler: InfrastructureHandler!
    private func getResponseFor(statusCode: Int) -> HTTPURLResponse {
        guard let url = URL(string: "https://www.google.com/"), let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil) else { fatalError() }
        return response
    }
    
    private func verify(response: HTTPURLResponse, equalTo expectedError: RESTError) {
        expect {
            try self.infrastructureHandler.verifyStatusCode(response)
        }.to(throwError(closure: { (error: ServiceError) in
            if case let .rest(error) = error {
                expect(error).to(equal(expectedError))
            } else { fail() }
        }))
    }
    
    override func setUp() {
        super.setUp()
        self.infrastructureHandler = InfrastructureHandler()
    }
    
    override func tearDown() {
        self.infrastructureHandler = nil
        super.tearDown()
    }
    
    func test_shouldThrow_notFoundError_when_statusCodeIs_404() {
        let response = getResponseFor(statusCode: 404)
        verify(response: response, equalTo: .notFound)
    }
    
    func test_shouldThrow_otherError_when_statusCodeIs_400() {
        let response = getResponseFor(statusCode: 400)
        verify(response: response, equalTo: .other)
    }
    
    func test_shouldThrow_internalServerError_when_statusCodeIs_599() {
        let response = getResponseFor(statusCode: 599)
        expect {
            try self.infrastructureHandler.verifyStatusCode(response)
        }.to(throwError { (error: ServiceError) in
            expect(error).to(equal(ServiceError.internalServerError))
        })
    }
    
    func test_shouldNotThrow_error_when_statusCodeIs_200() {
        let response = getResponseFor(statusCode: 200)
        expect {
            try self.infrastructureHandler.verifyStatusCode(response)
        }.toNot(throwError())
    }
}

extension ServiceError: Equatable {
    public static func ==(lhs: ServiceError, rhs: ServiceError) -> Bool {
        switch (lhs, rhs) {
        case let (.rest(error), .rest(error2)):
            return error == error2
        case let (.connection(error), .connection(error2)):
            return error == error2
        case (.jsonParse, .jsonParse):
            return true
        case (.internalServerError, .internalServerError):
            return true
        default:
            return false
        }
    }
}
