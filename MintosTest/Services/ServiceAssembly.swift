//
//  ServiceAssembly.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

import Swinject
import UIKit

final class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkConfiguration.self) { _ in
            NetworkConfigurationImpl()
        }
        .inObjectScope(.container)
        
        container.register(NetworkPerformer.self) { resolver in
            let configuration = resolver.resolve(NetworkConfiguration.self)!
            let requestBuilder = URLRequestBuilderImpl()
            let validator = StatusCodeValidatorImpl()
            let parser = DefaultParser()
            return NetworkPerformerImpl(
                configuration: configuration,
                requestBuilder: requestBuilder,
                validator: validator,
                parser: parser
            )
        }
        .inObjectScope(.container)
        
        container.register(PasteboardService.self) { _ in
            let pasteboard = UIPasteboard.general
            return PasteboardServiceImpl(pasteboard: pasteboard)
        }
        .inObjectScope(.container)
        
        container.register(LogService.self) { _ in
            LogServiceImpl()
        }
        .inObjectScope(.container)
     }
}
