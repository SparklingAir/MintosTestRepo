//
//  MintosResponseModel.swift
//  MintosTest
//
//  Created by Maksim Polous on 31/08/2023.
//

import Foundation

struct MintosResponseModel: Decodable, Equatable {
    struct Response: Decodable, Equatable {
        struct Item: Decodable, Equatable {
            let bank: String?
            let swift: String?
            let currency: String?
            let beneficiaryName: String?
            let beneficiaryBankAddress: String?
            let iban: String?
        }
        let paymentDetails: String?
        let items: [Item]?
    }
    let response: Response?
}
