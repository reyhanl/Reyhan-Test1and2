//
//  GetPromoOperation.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class GetPromoOperation: Operation {
    
    init() {
    }
    
    var request: RequestProtocol {
        return PromoRequest.getPromos
    }
    
    func execute(in dispatcher: Dispatcher, completion: @escaping(Result<[Promo], Error>) -> Void){
        dispatcher.execute(request: request) { result in
            switch result {
            case .success(let data):
                do{
                    let model = try JSONDecoder().decode(PromoResponseModel.self, from: data)
                    if let promos = model.promos{
                        completion(.success(promos))
                    }else{
                        completion(.failure(CustomError.somethingWentWrong))
                    }
                }catch{
                    completion(.failure(error))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
