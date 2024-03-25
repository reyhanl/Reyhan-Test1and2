//
//  Dispatcher.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation


protocol DispatcherProtocol{
    
    init(environment: Environment)
    
    func execute(request: RequestProtocol, completion: @escaping(Result<Data, Error>) -> Void)
}

class Dispatcher: DispatcherProtocol{
    
    var environment: Environment
    
    required init(environment: Environment) {
        self.environment = environment
    }
    
    func execute(request: RequestProtocol, completion: @escaping(Result<Data, Error>) -> Void) {
        //TODO: Should return a struct with a data or Codable
        do{
            let req = try makeRequest(request: request)
            print("url: \(req.url?.absoluteString ?? "")")
            URLSession.shared.dataTask(with: req, completionHandler: { data, response, error in
                if let error = error{
                    print("err: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                guard let data = data else{
                    completion(.failure(CustomError.somethingWentWrong))
                    return
                }
                
                print("response: \(response)")
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 300 && httpResponse.statusCode >= 200 else{
                    completion(.failure(CustomError.somethingWentWrong))
                    return
                }
                print(response as? HTTPURLResponse)
                completion(.success(data))
            }).resume()
        }catch{
            
        }
    }
    
    func makeRequest(request: RequestProtocol) throws -> URLRequest{
        let full_url = "\(environment.host ?? "")\(request.path)"
        guard let url =  URL(string: full_url) else{throw CustomError.somethingWentWrong}
        var url_request = URLRequest(url: url)
        
        // Working with parameters
        switch request.parameters {
        case .body(let params):
            // Parameters are part of the body
            if let params = params as? [String: String] { // just to simplify
                url_request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))
            } else {
                throw CustomError.somethingWentWrong
            }
        case .url(let params):
            // Parameters are part of the url
            if let params = params as? [String: String] { // just to simplify
                let query_params = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })
                guard var components = URLComponents(string: full_url) else {
                    throw CustomError.somethingWentWrong
                }
                components.queryItems = query_params
                url_request.url = components.url
            }
        }
        
        // Add headers from enviornment and request
        environment.headers.forEach { url_request.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        request.headers.forEach { url_request.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        
        // Setup HTTP method
        url_request.httpMethod = request.method.rawValue
        
        return url_request
    }
}
