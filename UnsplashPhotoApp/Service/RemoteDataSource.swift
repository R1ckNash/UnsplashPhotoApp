//
//  RemoteDataSource.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 25/05/2024.
//

import Foundation

struct Request {
    let method: String
    let path: String
    let parameters: [String: String]
    let needAuth: Bool
}

protocol RemoteDataSourceProtocol {
    func fetchPhotos(completion: @escaping (Result<[PhotoStruct], NetworkError>) -> Void)
}

final class RemoteDataSource: RemoteDataSourceProtocol {
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchPhotos(completion: @escaping (Result<[PhotoStruct], NetworkError>) -> Void) {
        let request = Request(method: "GET", path: "/photos", parameters: ["client_id": "ele1O-gBShRYQQFqvXmPTadelGhYMuVFF2Dz3019bzc"], needAuth: false)
        
        networkManager.makeRequest(request: request) { (result: Result<[PhotoStruct], NetworkError>) in
            completion(result)
        }
    }
    
}
