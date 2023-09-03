//
//  CurrencyPickerViewModel.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

import RxSwift
import RxCocoa

struct CurrencyPickerArgument {
    let current: Currency
    let didSelect: AnyObserver<Currency>
}

protocol CurrencyPickerViewModel {
    var title: String { get }
    var items: [CurrencyPickerCellModel] { get }
}

final class CurrencyPickerViewModelImpl: CurrencyPickerViewModel {
    let title: String
    var items: [CurrencyPickerCellModel] = []
    
    private let bag = DisposeBag()
    
    init(argument: CurrencyPickerArgument) {
        title = "Select currency"
        
        /// TODO: This screen must have its own iterator and mapper to get and handle supported currencies from the server.

        let count = Currency.allCases.count
        let _selected = BehaviorRelay(value: argument.current)
        
        items = Currency.allCases.enumerated().map { index, currency in
            let _isSelected = BehaviorRelay(value: false)
            _selected.map { $0 == currency }.bind(to: _isSelected).disposed(by: bag)
            
            let _didTap = PublishSubject<Void>()
            _didTap.map { currency }.bind(to: _selected).disposed(by: bag)
            _didTap.subscribe(onNext: { argument.didSelect.onNext(currency) }).disposed(by: bag)
            
            return CurrencyPickerCellModel(
                title: currency.rawValue.uppercased(),
                showSeparator: index < count - 1,
                isSelected: _isSelected.asDriver(),
                didTap: _didTap.asObserver()
            )
        }
    }
}
