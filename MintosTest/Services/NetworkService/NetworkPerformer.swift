//
//  NetworkPerformer.swift
//  MintosTest
//
//  Created by Maksim Polous on 31/08/2023.
//

import Foundation
import RxSwift

protocol NetworkPerformer {
    func get<T: Decodable>(_ type: T.Type, _ request: Request) -> Single<T>
}

final class NetworkPerformerImpl: NetworkPerformer {
    private let configuration: NetworkConfiguration
    private let requestBuilder: URLRequestBuilder
    private let validator: StatusCodeValidator
    private let parser: Parser
    
    init(
        configuration: NetworkConfiguration,
        requestBuilder: URLRequestBuilder,
        validator: StatusCodeValidator,
        parser: Parser
    ) {
        self.configuration = configuration
        self.requestBuilder = requestBuilder
        self.validator = validator
        self.parser = parser
    }
    
    func get<T: Decodable>(_ type: T.Type, _ request: Request) -> Single<T> {
        let parser = self.parser
        let getData = self.getData
        return requestBuilder.makeURLRequest(from: request)
            .flatMap { urlRequest in
                getData(urlRequest)
            }
            .flatMap { data in
                parser.parse(type, data)
            }
    }
    
    private func getData(_ request: URLRequest) -> Single<Data> {
        let config = self.configuration
        let validator = self.validator
        return Single.create { single in
            let task = config.urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(NetworkError.sessionTaskFailed(error: error)))
                    return
                }
                if let response = response {
                    do {
                        try validator.validate(response)
                    } catch {
                        single(.failure(error))
                        return
                    }
                }
                if let data = data {
                    single(.success(data))
                } else {
                    single(.failure(NetworkError.validationFailed(reason: .inputDataNil)))
                }
            }
            task.resume()
            return Disposables.create()
        }
    }
}
