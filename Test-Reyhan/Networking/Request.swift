//
//  Request.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

protocol RequestProtocol{
    var path: String{get}
    var method: HTTPMethod{get}
    var parameters: RequestParams{get}
    var headers: [String:Any]{get}
    var dataType: DataType{get}
}

public enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
}

public enum RequestParams {
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?)
}

public enum DataType {
    case JSON
    case Data
}
