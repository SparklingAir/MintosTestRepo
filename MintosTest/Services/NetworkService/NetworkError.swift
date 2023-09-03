//
//  NetworkError.swift
//  MintosTest
//
//  Created by Maksim Polous on 31/08/2023.
//

import Foundation

enum NetworkError: Error {
    enum ValidationFailureReason {
        case badStatusCode(code: Int, headers: [AnyHashable : Any])
        case inputDataNil
    }
    enum SerializationFailureReason {
        case inputDataEmpty
        case jsonSerializationFailed(error: Error)
    }
    
    case requestBuildingFailed
    case sessionTaskFailed(error: Error)
    case validationFailed(reason: ValidationFailureReason)
    case serializationFailed(reason: SerializationFailureReason)
}
