//
//  NetworkManager.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchPhotos(completion: @escaping (Result<[PhotoStruct], NetworkError>) -> Void)
    
    func makeRequest<T: Decodable>(request: Request, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    let jsonDecoder: JSONDecoder
    
    init(jsonDecoder: JSONDecoder) {
        self.jsonDecoder = jsonDecoder
    }
    
    func makeRequest<T: Decodable>(request: Request, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard var urlComponents = URLComponents(string: Constants.host) else {
            completion(.failure(.custom("Invalid URL components")))
            return
        }
        
        urlComponents.path = request.path
        if !request.parameters.isEmpty {
            urlComponents.queryItems = request.parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
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
        
    }
    
    func fetchPhotos(completion: @escaping (Result<[PhotoStruct], NetworkError>) -> Void) {
        guard let url = URL(string: Constants.host) else {
            completion(.failure(NetworkError.custom("Invalid URL")))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.custom(error.localizedDescription)))
            } else {
                guard let data = data else {
                    completion(.failure(NetworkError.custom("No data received")))
                    return
                }
                
                do {
                    let photos = try self.jsonDecoder.decode([PhotoStruct].self, from: data)
                    completion(.success(photos))
                } catch {
                    completion(.failure(NetworkError.invalidURL))
                }
            }
            
        }
        task.resume()
    }
}

//MARK: - Network Error enum

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case custom(String)
}
