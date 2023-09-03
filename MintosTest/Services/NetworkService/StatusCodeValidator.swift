//
//  StatusCodeValidator.swift
//  MintosTest
//
//  Created by Maksim Polous on 31/08/2023.
//

import Foundation

protocol StatusCodeValidator {
    func validate(_ resonse: URLResponse) throws
}

struct StatusCodeValidatorImpl: StatusCodeValidator {
    func validate(_ resonse: URLResponse) throws {
        guard let httpResponse = resonse as? HTTPURLResponse else {
            return
        }
        guard !(200 ..< 300).contains(httpResponse.statusCode) else {
            return
        }
        throw NetworkError.validationFailed(reason: .badStatusCode(
            code: httpResponse.statusCode,
            headers: httpResponse.allHeaderFields
        ))
    }
}
