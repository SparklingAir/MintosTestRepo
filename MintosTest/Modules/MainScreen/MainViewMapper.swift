//
//  MainViewMapper.swift
//  MintosTest
//
//  Created by Maksim Polous on 01/08/2023.
//

import Foundation
import RxSwift

protocol MainViewMapper {
    func getItems(
        response: MintosResponseModel,
        currentCurrency: Currency,
        didCopy: AnyObserver<String>
    ) -> [CommonCellModel]
}

final class MainViewMapperImpl: MainViewMapper {
    private let bag = DisposeBag()
    
    func getItems(
        response: MintosResponseModel,
        currentCurrency: Currency,
        didCopy: AnyObserver<String>
    ) -> [CommonCellModel] {
        var out: [CommonCellModel] = []
        if let response = response.response,
           let investorId = response.paymentDetails?.components(separatedBy: " ").last,
           let items = response.items
        {
            let _didCopy = PublishSubject<String>()
            _didCopy.subscribe(onNext: { didCopy.onNext($0) }).disposed(by: bag)
            
            let result = items.compactMap { item -> BankDetailsCellModel? in
                guard let title = item.bank, !title.isEmpty, item.currency?.isEmpty == false else { return nil }
                
                if let currency = item.currency?.lowercased(), let currencyModel = Currency(rawValue: currency),
                   currentCurrency != currencyModel {
                    return nil
                }
                
                let titleModel = BankDetailTitleViewModel(title: title)
                
                let _didTapIban = PublishSubject<Void>()
                let ibanModel = BankDetailItemViewModel(
                    title: "Beneficiary bank account number / IBAN",
                    subTitle: item.iban ?? "",
                    showSeparator: false,
                    didTapCopy: _didTapIban.asObserver()
                )
                _didTapIban.map { item.iban ?? "" }.bind(to: _didCopy).disposed(by: bag)
                
                let _didTapSwift = PublishSubject<Void>()
                let swiftModel = BankDetailItemViewModel(
                    title: "Beneficiary bank SWIFT / BIC code",
                    subTitle: item.swift ?? "",
                    showSeparator: true,
                    didTapCopy: _didTapSwift.asObserver()
                )
                _didTapSwift.map { item.swift ?? "" }.bind(to: _didCopy).disposed(by: bag)
                
                let _didTapName = PublishSubject<Void>()
                let nameModel = BankDetailItemViewModel(
                    title: "Beneficiary name",
                    subTitle: item.beneficiaryName ?? "",
                    showSeparator: true,
                    didTapCopy: _didTapName.asObserver()
                )
                _didTapName.map { item.beneficiaryName ?? "" }.bind(to: _didCopy).disposed(by: bag)
                
                let _didTapAddress = PublishSubject<Void>()
                let addressModel = BankDetailItemViewModel(
                    title: "Beneficiary address",
                    subTitle: item.beneficiaryBankAddress ?? "",
                    showSeparator: true,
                    didTapCopy: _didTapAddress.asObserver()
                )
                _didTapAddress.map { item.beneficiaryBankAddress ?? "" }.bind(to: _didCopy).disposed(by: bag)
                
                return BankDetailsCellModel(
                    items: [titleModel, ibanModel, swiftModel, nameModel, addressModel]
                )
            }
            
            if result.isEmpty {
                out.append(TextCellModel(
                    title: "Nothing found for this currency"
                ))
            } else {
                out.append(TitleCellModel(
                    title: "Bank transfer",
                    subTitle: "Transfer money from your bank account to your Mntos account"
                ))
                
                let _didTapInvestorCopy = PublishSubject<Void>()
                out.append(InvestorCellModel(
                    title: "Add this information to payment details",
                    subTitle: "\(investorId) - Investor",
                    didTapCopy: _didTapInvestorCopy.asObserver()
                ))
                _didTapInvestorCopy.map { investorId }.bind(to: _didCopy).disposed(by: bag)
                
                out.append(contentsOf: result)
            }
        }
        return out
    }
}
