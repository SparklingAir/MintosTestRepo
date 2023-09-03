//
//  NetworkMethod.swift
//  MintosTest
//
//  Created by Maksim Polous on 31/08/2023.
//

public enum HTTPMethod: String, Decodable {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case update = "UPDATE"
    case put = "PUT"
    case patch = "PATCH"
}
