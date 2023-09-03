//
//  Parser.swift
//  MintosTest
//
//  Created by Maksim Polous on 31/08/2023.
//

import Foundation
import RxSwift

protocol Parser {
    func parse<T: Decodable>(_ type: T.Type, _ data: Data) -> Single<T>
}

struct DefaultParser: Parser {
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }
    
    func parse<T: Decodable>(_ type: T.Type, _ data: Data) -> Single<T> {
        Single.create { single in
            if data.isEmpty {
                if type is NoResponse.Type, let response = NoResponse() as? T {
                    single(.success(response))
                } else {
                    single(.failure(NetworkError.serializationFailed(reason: .inputDataEmpty)))
                }
                return Disposables.create()
            }
            do {
                let result = try self.decoder.decode(T.self, from: data)
                single(.success(result))
            } catch {
                single(.failure(NetworkError.serializationFailed(reason: .jsonSerializationFailed(error: error))))
            }
            return Disposables.create()
        }
    }
}
