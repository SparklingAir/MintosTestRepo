//
//  DesignSystemAssembly.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

import Swinject

final class DesignSystemAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NavigationController.self) { _ in
            NavigationController()
        }
        container.register(RootNavController.self) { _ in
            RootNavController()
        }
        .inObjectScope(.container)
    }
}
