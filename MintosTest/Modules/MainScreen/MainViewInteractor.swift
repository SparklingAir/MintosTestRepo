//
//  MainViewInteractor.swift
//  MintosTest
//
//  Created by Maksim Polous on 02/09/2023.
//

import RxSwift

protocol MainViewInteractor {
    func getBankDetails() -> Single<MintosResponseModel>
}

final class MainViewInteractorImpl: MainViewInteractor {
    private let performer: NetworkPerformer
    private let configuration: NetworkConfiguration
    
    init(performer: NetworkPerformer, configuration: NetworkConfiguration) {
        self.performer = performer
        self.configuration = configuration
    }
    
    func getBankDetails() -> Single<MintosResponseModel> {
        let request = RegularRequest(
            path: configuration.basePath,
            method: .get
        )
        return performer.get(MintosResponseModel.self, request)
    }
}
