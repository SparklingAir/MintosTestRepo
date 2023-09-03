//
//  ModuleAssembly.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

import Swinject

enum ModuleAssembly {
    static func registerDependencies(container: Container, router: AppRouter) {
        container.register(MainViewController.self) { resolver in
            let configuration = resolver.resolve(NetworkConfiguration.self)!
            let performer = resolver.resolve(NetworkPerformer.self)!
            let interator = MainViewInteractorImpl(performer: performer, configuration: configuration)
            let mapper = MainViewMapperImpl()
            let pasteboard = resolver.resolve(PasteboardService.self)!
            let logger = resolver.resolve(LogService.self)!
            let viewModel = MainViewModelImpl(
                interactor: interator,
                mapper: mapper,
                router: router,
                pasteboard: pasteboard,
                logger: logger
            )
            return MainViewController(viewMode: viewModel)
        }
        
        container.register(CurrencyPickerViewController.self) { resolver, argument in
            let viewModel = CurrencyPickerViewModelImpl(argument: argument)
            return CurrencyPickerViewController(viewModel: viewModel)
        }
    }
}
