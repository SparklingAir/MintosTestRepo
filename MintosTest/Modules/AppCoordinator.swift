//
//  AppCoordinator.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

import XCoordinator
import Swinject

typealias AppRouter = WeakRouter<AppRoute>

enum AppRoute: Route {
    enum AlertKind {
        enum NetworkErrorKind {
            case noInternetConnection
            case serviceUnavailable
        }
        case networkError(NetworkErrorKind)
        case copiedToBuffer(String)
    }
    case home
    case alert(AlertKind)
    case currencySelection(CurrencyPickerArgument)
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
        let rootController = resolver.resolve(NavigationController.self)!
        super.init(rootViewController: rootController)
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .home:
            let vc = resolver.resolve(MainViewController.self)!
            return .set([vc])
        case .currencySelection(let argument):
            let vc = resolver.resolve(CurrencyPickerViewController.self, argument: argument)!
            vc.modalPresentationStyle = .pageSheet
            if let sheetController = vc.sheetPresentationController {
                sheetController.prefersGrabberVisible = true
                sheetController.detents = [.medium()]
            }
            return .present(vc)
        case .alert(let kind):
            switch kind {
            case .networkError(let networkKind):
                switch networkKind {
                case .serviceUnavailable:
                    let alert = UIAlertController(title: "Service not available at the moment", message: "Please try again later", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(ok)
                    return .present(alert)
                case .noInternetConnection:
                    let alert = UIAlertController(title: "No internet connection", message: "Try to reconnect your phone to the Internet", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(ok)
                    return .present(alert)
                }
            case .copiedToBuffer(let text):
                let alert = UIAlertController(title: text, message: "copied to clipboard", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(ok)
                return .present(alert)
            }
        }
    }
}
