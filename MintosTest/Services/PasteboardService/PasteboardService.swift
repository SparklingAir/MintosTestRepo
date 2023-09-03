//
//  PasteboardService.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

import UIKit

protocol PasteboardService {
    func write(_ text: String)
    func read() -> String?
}

final class PasteboardServiceImpl: PasteboardService {
    private let pasteboard: UIPasteboard
    
    init(pasteboard: UIPasteboard) {
        self.pasteboard = pasteboard
    }
    
    func write(_ text: String) {
        pasteboard.string = text
    }
    
    func read() -> String? {
        pasteboard.string
    }
}
