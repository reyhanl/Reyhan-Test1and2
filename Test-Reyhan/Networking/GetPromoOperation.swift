//
//  GetPromoOperation.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Combine

class GetPromoOperation: Operation {
    typealias T = Promo
    
    
    init() {
    }
    
    var request: RequestProtocol {
        return PromoRequest.getPromos
    }
    
    func execute<T: Decodable>(in dispatcher: Dispatcher) -> AnyPublisher<T, Error>{
        return dispatcher.execute(request: request)
    }
}
