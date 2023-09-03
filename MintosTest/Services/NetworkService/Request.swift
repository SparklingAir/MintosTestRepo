//
//  Request.swift
//  MintosTest
//
//  Created by Maksim Polous on 31/08/2023.
//

protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}

public struct RegularRequest: Request {
    public let path: String
    public let method: HTTPMethod
    public var body: Encodable?
    public var headers: [String: String]?

    public init(
        path: String,
        method: HTTPMethod,
        parameters: Encodable? = nil,
        headers: [String: String]? = nil
    ) {
        self.path = path
        self.method = method
        self.body = parameters
        self.headers = headers
    }
}
