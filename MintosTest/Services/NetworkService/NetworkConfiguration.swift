//
//  NetworkConfiguration.swift
//  MintosTest
//
//  Created by Maksim Polous on 31/08/2023.
//

import Foundation

protocol NetworkConfiguration {
    var basePath: String { get }
    var urlSession: URLSession { get }
}

struct NetworkConfigurationImpl: NetworkConfiguration {
    let basePath = "https://mintos-mobile.s3.eu-central-1.amazonaws.com/bank-accounts.json"
    let urlSession = URLSession.shared
}
