//
//  PromoRequest.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

enum PromoRequest: RequestProtocol{
    
    case getPromos
    
    var path: String{
        switch self {
        case .getPromos:
            return "promos"
        }
    }
    
    var method: HTTPMethod{
        return .get
    }
    
    var parameters: RequestParams{
        switch self {
        case .getPromos:
            return .url(nil)
        }
    }
    
    var headers: [String : Any]{
        return [:]
    }
    
    var dataType: DataType{
        switch self{
        case .getPromos:
            return .JSON
        }
    }
}
