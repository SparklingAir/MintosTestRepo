//
//  ValidatorTest.swift
//  MintosTestTests
//
//  Created by Maksim Polous on 02/09/2023.
//

@testable import MintosTest
import XCTest

final class ValidatorTest: XCTestCase {
    
    var validator: StatusCodeValidator!
    
    override func setUp() {
        validator = StatusCodeValidatorImpl()
        super.setUp()
    }
    
    override func tearDown() {
        validator = nil
        super.tearDown()
    }
    
    func testWrongCode() throws {
        let url = URL(string: "https://mintos-mobile.s3.eu-central-1.amazonaws.com/bank-accounts.json")!
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
        do {
            try validator.validate(response)
            XCTFail("Expected failure but got success")
        } catch {
            guard case .validationFailed(let reason) = error as? NetworkError,
                case .badStatusCode(let code, _) = reason,
                  code == 404
            else {
                XCTFail("Unexpected error: \(error)")
                return
            }
        }
    }
}
