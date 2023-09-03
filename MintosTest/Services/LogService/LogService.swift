//
//  LogService.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

protocol LogService {
    func log(_ item: Any...)
}

final class LogServiceImpl: LogService {
    func log(_ item: Any...) {
        #if DEBUG
        print("LogService: \(item)")
        #endif
    }
}
