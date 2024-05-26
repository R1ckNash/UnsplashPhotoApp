//
//  Storage.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 26/05/2024.
//

import Foundation

final class Storage {
    static let shared = Storage()
    private let photoCache = NSCache<NSString, NSArray>()
    
    private init() {}
    
    func getPhotos(forKey key: String) -> [PhotoDTO]? {
        return photoCache.object(forKey: key as NSString) as? [PhotoDTO]
    }
    
    func savePhotos(_ photos: [PhotoDTO], forKey key: String) {
        photoCache.setObject(photos as NSArray, forKey: key as NSString)
    }
}
