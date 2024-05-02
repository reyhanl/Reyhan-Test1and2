//
//  Operation.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Combine

protocol Operation {
    associatedtype T: Codable
    /// Request to execute
    var request: RequestProtocol { get }
    
    
    /// Execute request in passed dispatcher
    ///
    /// - Parameter dispatcher: dispatcher
    /// - Returns: a promise
    func execute<T: Decodable>(in dispatcher: Dispatcher) -> AnyPublisher<T, Error>
    
}
