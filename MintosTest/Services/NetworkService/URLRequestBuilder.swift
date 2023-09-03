//
//  URLRequestBuilder.swift
//  MintosTest
//
//  Created by Maksim Polous on 31/08/2023.
//

import Foundation
import RxSwift

protocol URLRequestBuilder {
    func makeURLRequest(from request: Request) -> Single<URLRequest>
}

struct URLRequestBuilderImpl: URLRequestBuilder {
    func makeURLRequest(from request: Request) -> Single<URLRequest> {
        Single.create { single in
            guard let url = URL(string: request.path) else {
                single(.failure(NetworkError.requestBuildingFailed))
                return Disposables.create()
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = request.method.rawValue
            
            if let parameters = request.body {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = try? JSONEncoder().encode(parameters)
            }
            request.headers?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
            
            single(.success(urlRequest))
            return Disposables.create()
        }
    }
}
