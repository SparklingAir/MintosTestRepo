//
//  MarginHelper.swift
//  MintosTest
//
//  Created by Maksim Polous on 01/08/2023.
//

import UIKit

enum MarginHelper {
    static var safeAreaMaxY: CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return (scene?.windows.first?.safeAreaInsets ?? .zero).top
    }
    
    static var typicalNavbarHeight: CGFloat {
        safeAreaMaxY + 44
    }
    
    static func navbarMaxY(_ nc: UINavigationController?) -> CGFloat {
        let navbarHeight = nc?.navigationBar.frame.height ?? 0
        return safeAreaMaxY + navbarHeight
    }
}
