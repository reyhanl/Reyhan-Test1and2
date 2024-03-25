//
//  PromoInteractor.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class PromoInteractor: PromoPresenterToInteractorProtocol{
    var presenter: PromoInteractorToPresenterProtocol?
    
    func fetchPromos() {
        guard let key = UserDefaults.standard.value(forKey: tokenKey) as? String else{return}
        let env = Environment(name: "", host: URLManager.baseUrl, headers: ["autorization": "Bearer \(key)"], cachePolicy: .reloadRevalidatingCacheData)
        let dispatcher = Dispatcher(environment: env)
        let operation = GetPromoOperation()
        operation.execute(in: dispatcher) { [weak self] result in
            guard let self = self else{return}
            switch result{
            case .success(let promos):
                self.presenter?.result(result: .success(.fetchPromoSuccess(promos)))
            case .failure(let error):
                self.presenter?.result(result: .failure(error))
            }
        }
    }
}
