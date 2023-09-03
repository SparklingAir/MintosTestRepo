//
//  NavigationController.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

import UIKit

/// This class is supposed to share common visual settings. It is allowed to have more than one instance.
class NavigationController: UINavigationController {}

/// This one is intended to be used as the root navigation controller. It's supposed to have a single instance.
class RootNavController: NavigationController {}
