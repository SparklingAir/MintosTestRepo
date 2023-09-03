//
//  ParserTest.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

@testable import MintosTest
import XCTest
import RxSwift

final class ParserTest: XCTestCase {
    
    var parser: Parser!
    let bag = DisposeBag()

    override func setUp() {
        parser = DefaultParser()
        super.setUp()
    }

    override func tearDown() {
        parser = nil
        super.tearDown()
    }

    func testFullData() throws {
        let data = fullResponseJson.data(using: .utf8)!
        let expected = MintosResponseModel(response: .init(
            paymentDetails: "Investor ID: 54361338",
            items: [
                .init(
                    bank: "Acme Bank",
                    swift: "ACMEUS33",
                    currency: "EUR",
                    beneficiaryName: "AS Mintos Marketplace",
                    beneficiaryBankAddress: "10 Rue de la Paix, 75002 Paris, France",
                    iban: "GB29NWBK60161331926819"
                ),
                .init(
                    bank: "City Bank",
                    swift: "CITIUS33",
                    currency: "USD",
                    beneficiaryName: "AS Mintos Marketplace",
                    beneficiaryBankAddress: "123 Main Street, New York, NY, USA",
                    iban: "US12345678901234567890"
                ),
                .init(
                    bank: "EuroBank Poland",
                    swift: "EURBPLPW",
                    currency: "PLN",
                    beneficiaryName: "AS Mintos Marketplace",
                    beneficiaryBankAddress: "567 Maple Avenue, Warsaw, Poland",
                    iban: "PL87654321098765432109"
                ),
            ])
        )
        parser.parse(MintosResponseModel.self, data)
            .subscribe(
                onSuccess: { result in
                    XCTAssertEqual(result, expected)
                },
                onFailure: { error in
                    XCTFail("Expected success but got \(error)")
                }
            )
            .disposed(by: bag)
    }
    
    func testPartialData() throws {
        let data = partialResponseJson.data(using: .utf8)!
        let expected = MintosResponseModel(response: .init(
            paymentDetails: nil,
            items: [
                .init(
                    bank: nil,
                    swift: "ACMEUS33",
                    currency: nil,
                    beneficiaryName: nil,
                    beneficiaryBankAddress: nil,
                    iban: nil
                ),
                .init(
                    bank: "City Bank",
                    swift: nil,
                    currency: nil,
                    beneficiaryName: nil,
                    beneficiaryBankAddress: nil,
                    iban: nil
                ),
                .init(
                    bank: nil,
                    swift: nil,
                    currency: nil,
                    beneficiaryName: "AS Mintos Marketplace",
                    beneficiaryBankAddress: nil,
                    iban: nil
                ),
            ])
        )
        parser.parse(MintosResponseModel.self, data)
            .subscribe(
                onSuccess: { result in
                    XCTAssertEqual(result, expected)
                },
                onFailure: { error in
                    XCTFail("Expected success but got \(error)")
                }
            )
            .disposed(by: bag)
    }
    
    func testEmptyData() throws {
        let data = Data()
        parser.parse(MintosResponseModel.self, data)
            .subscribe(
                onSuccess: { _ in
                    XCTFail("Expected failure but got success")
                },
                onFailure: { error in
                    guard let networkError = error as? NetworkError,
                          case .serializationFailed(let reason) = networkError,
                          case .inputDataEmpty = reason
                    else {
                        XCTFail("Unexpected error: \(error)")
                        return
                    }
                }
            )
            .disposed(by: bag)
    }
}
