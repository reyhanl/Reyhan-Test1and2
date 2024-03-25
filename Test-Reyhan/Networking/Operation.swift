//
//  Operation.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

protocol Operation {
    associatedtype T: Codable
    /// Request to execute
    var request: RequestProtocol { get }
    
    
    /// Execute request in passed dispatcher
    ///
    /// - Parameter dispatcher: dispatcher
    /// - Returns: a promise
    func execute(in dispatcher: Dispatcher, completion: @escaping(Result<T, Error>) -> Void)
    
}
