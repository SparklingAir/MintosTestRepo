//
//  MainViewModel.swift
//  MintosTest
//
//  Created by Maksim Polous on 31/08/2023.
//

import RxSwift
import RxCocoa

protocol MainViewModel {
    var currencySelectionViewModel: CurrencySelectionViewModel { get }
    var viewWillAppear: AnyObserver<Void> { get }
    var items: Driver<[CommonCellModel]> { get }
    var showLoading: Driver<Bool> { get }
}

final class MainViewModelImpl: MainViewModel {
    let currencySelectionViewModel: CurrencySelectionViewModel
    let viewWillAppear: AnyObserver<Void>
    let items: Driver<[CommonCellModel]>
    let showLoading: Driver<Bool>
    
    private let interactor: MainViewInteractor
    private let mapper: MainViewMapper
    private let logger: LogService
    private let router: AppRouter
    
    private let bag = DisposeBag()
    
    init(
        interactor: MainViewInteractor,
        mapper: MainViewMapper,
        router: AppRouter,
        pasteboard: PasteboardService,
        logger: LogService
    ) {
        // MARK: - Common init
        
        self.interactor = interactor
        self.mapper = mapper
        self.router = router
        self.logger = logger
        
        let _viewWillAppear = PublishSubject<Void>()
        viewWillAppear = _viewWillAppear.asObserver()
        
        let _showLoading = BehaviorRelay(value: true)
        showLoading = _showLoading.asDriver()
        
        // MARK: - Currency view
        
        let _currency = BehaviorRelay<Currency>(value: .eur)
        let _didTapCurrencyArrow = PublishSubject<Void>()
        currencySelectionViewModel = .init(
            title: "Currency",
            currency: _currency.map { $0.rawValue.uppercased() }.asDriver(onErrorJustReturn: ""),
            didTap: _didTapCurrencyArrow.asObserver()
        )
        let _didSelectCurrency = PublishSubject<Currency>()
        _didTapCurrencyArrow
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .withLatestFrom(_currency) { $1 }
            .subscribe(onNext: { currentCurrency in
                let argument = CurrencyPickerArgument(
                    current: currentCurrency,
                    didSelect: _didSelectCurrency.asObserver()
                )
                router.trigger(.currencySelection(argument))
            })
            .disposed(by: bag)
        _didSelectCurrency.bind(to: _currency).disposed(by: bag)
        
        // MARK: - Items
        
        let _items = BehaviorRelay<[CommonCellModel]>(value: [])
        items = _items.asDriver()
        
        let _didCopy = PublishSubject<String>()
        _didCopy.subscribe(onNext: { text in
            pasteboard.write(text)
            router.trigger(.alert(.copiedToBuffer(text)))
        })
        .disposed(by: bag)
        
        let currencyChange = _currency
            .skip(1)
            .distinctUntilChanged()
            .map { _ in Void() }
        
        Observable.merge(_viewWillAppear.take(1), currencyChange)
            .subscribe(onNext: { [weak self] in
                _showLoading.accept(true)
                self?.getItems(
                    currency: _currency,
                    didCopy: _didCopy,
                    showLoading: _showLoading,
                    items: _items
                )
            })
            .disposed(by: bag)
    }
    
    // MARK: - Private methods
    
    private func getItems(
        currency: BehaviorRelay<Currency>,
        didCopy: PublishSubject<String>,
        showLoading: BehaviorRelay<Bool>,
        items: BehaviorRelay<[CommonCellModel]>
    ) {
        interactor.getBankDetails().asObservable()
            .withLatestFrom(currency) { ($0, $1) }
            .compactMap { [weak self] response, currentCurrency in
                self?.mapper.getItems(response: response, currentCurrency: currentCurrency, didCopy: didCopy.asObserver())
            }
            .subscribe(
                onNext: { result in
                    items.accept(result)
                },
                onError: { [weak self] error in
                    self?.logger.log(error)
                    items.accept([TextCellModel(title: "Service not available at the moment.\nPlease try again later.")])
                },
                onDisposed: {
                    showLoading.accept(false)
                }
            )
            .disposed(by: bag)
    }
}
