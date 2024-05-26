//
//  NetworkManager.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation

struct RunningRequest {
    var cancelMethod: () -> Void
    
    func cancel() {
        cancelMethod()
    }
}

protocol NetworkManagerProtocol {
    func makeCancellableRequest<T: Decodable>(request: Request, completion: @escaping (Result<T, NetworkError>) -> Void) -> RunningRequest
    func makeRequest<T: Decodable>(request: Request, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    let jsonDecoder: JSONDecoder
    
    init(jsonDecoder: JSONDecoder) {
        self.jsonDecoder = jsonDecoder
    }
    
    func makeCancellableRequest<T: Decodable>(request: Request, completion: @escaping (Result<T, NetworkError>) -> Void) -> RunningRequest {
        
        guard var urlComponents = URLComponents(string: Constants.host) else {
            completion(.failure(.custom("Invalid URL components")))
            return RunningRequest(cancelMethod: {})
        }
        
        urlComponents.path = request.path
        if !request.parameters.isEmpty {
            urlComponents.queryItems = request.parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return RunningRequest(cancelMethod: {})
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        
        if request.needAuth {
            urlRequest.addValue("Bearer <token>", forHTTPHeaderField: "Authorization")
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.custom("No data received")))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch let decodingError {
                completion(.failure(.decodingFailed(decodingError)))
            }
        }
        
        task.resume()
        
        return RunningRequest(cancelMethod: { task.cancel() })
    }
    
    func makeRequest<T: Decodable>(request: Request, completion: @escaping (Result<T, NetworkError>) -> Void) {
        _ = makeCancellableRequest(request: request, completion: completion)
    }
}

//MARK: - Network Error enum

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case custom(String)
}
