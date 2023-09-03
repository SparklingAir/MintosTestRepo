//
//  AppDelegate.swift
//  MintosTest
//
//  Created by Maksim Polous on 31/08/2023.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var container: Container?
    private var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let container = Container()
        self.container = container
        Assembler(container: container).apply(assemblies: [
            ServiceAssembly(),
            DesignSystemAssembly()
        ])
        
        let coordinator = AppCoordinator(resolver: container)
        self.coordinator = coordinator
        let router = coordinator.weakRouter
        ModuleAssembly.registerDependencies(container: container, router: router)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        router.setRoot(for: window)
        
        router.trigger(.home)
        
        return true
    }
}

