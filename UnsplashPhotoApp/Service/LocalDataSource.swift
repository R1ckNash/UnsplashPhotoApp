//
//  LocalDataSource.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 25/05/2024.
//

import Foundation

protocol LocalDataSourceProtocol {
    func fetchPhotos(completion: @escaping ([PhotoDTO]?) -> Void)
    func savePhotos(_ photos: [PhotoDTO])
}

final class LocalDataSource: LocalDataSourceProtocol {
    private let cacheKey = "photos"
    
    func fetchPhotos(completion: @escaping ([PhotoDTO]?) -> Void) {
            let cachedPhotos = Storage.shared.getPhotos(forKey: cacheKey)
            completion(cachedPhotos)
        }
        
        func savePhotos(_ photos: [PhotoDTO]) {
            Storage.shared.savePhotos(photos, forKey: cacheKey)
        }
}
