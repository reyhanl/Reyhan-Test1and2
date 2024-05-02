//
//  PromoInteractor.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Combine
import Foundation

class PromoInteractor: PromoPresenterToInteractorProtocol{
    var presenter: PromoInteractorToPresenterProtocol?
    
    func fetchPromos() -> AnyPublisher<[Promo], Error> {
        guard let key = UserDefaults.standard.value(forKey: tokenKey) as? String else{
            return Fail(error: NSError(domain: "Server Error", code: 0))
                .eraseToAnyPublisher()
        }
        let env = Environment(name: "", host: URLManager.baseUrl, headers: ["autorization": "Bearer \(key)"], cachePolicy: .reloadRevalidatingCacheData)
        let dispatcher = Dispatcher(environment: env)
        let operation = GetPromoOperation()
        return operation.execute(in: dispatcher)
    }
}
