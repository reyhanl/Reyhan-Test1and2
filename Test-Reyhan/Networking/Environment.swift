//
//  Environment.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class Environment{
    var name: String?
    var host: String?
    var headers: [String:Any] = [:]
    var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    
    init(name: String? = nil, host: String? = nil, headers: [String : Any], cachePolicy: URLRequest.CachePolicy) {
        self.name = name
        self.host = host
        self.headers = headers
        self.cachePolicy = cachePolicy
    }
}

