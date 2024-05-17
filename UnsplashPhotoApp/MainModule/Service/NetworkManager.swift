//
//  NetworkManager.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchPhotos(completion: @escaping (Result<[Photo], Error>) -> Void)
}

//MARK: - Network Manager
class NetworkManager: NetworkManagerProtocol {
    
    lazy var jsonDecoder: JSONDecoder = {
        JSONDecoder()
    }()
    
    func fetchPhotos(completion: @escaping (Result<[Photo], any Error>) -> Void) {
        guard let url = URL(string: Constants.serverUrl) else {
            completion(.failure(NetworkError.custom("Invalid URL")))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.custom(error.localizedDescription)))
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.custom("No data received")))
                return
            }
            
            do {
                let photos = try self.jsonDecoder.decode([Photo].self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

//MARK: - Network Error enum
enum NetworkError: Error {
    case unavailable
    case status(Int)
    case custom(String)
    
    var message: String {
        switch self {
        case .unavailable:
            return "Server is not available"
        case .status(let code):
            return "The HTTP status code is \(code)"
        case .custom(let description):
            return description
        }
    }
}

