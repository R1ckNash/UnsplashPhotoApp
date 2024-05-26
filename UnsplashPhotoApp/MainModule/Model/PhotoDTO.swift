//
//  PhotoDTO.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 26/05/2024.
//

import Foundation

final class PhotoDTO: NSObject, Decodable {
    let id: String
    let color: String
    let desc: String?
    let altDescription: String
    let likes: Int
    let urls: ImageUrls
    let user: User
    
    init(id: String, color: String, desc: String?, altDescription: String, likes: Int, urls: ImageUrls, user: User) {
        self.id = id
        self.color = color
        self.desc = desc
        self.altDescription = altDescription
        self.likes = likes
        self.urls = urls
        self.user = user
    }
    
    var photoDescription: String {
        return desc ?? altDescription
    }
    
    final class ImageUrls: NSObject, Decodable {
        let thumb: String
        let regular: String
        
        init(thumb: String, regular: String) {
            self.thumb = thumb
            self.regular = regular
        }
    }
    
    final class User: NSObject, Decodable {
        let username: String
        
        init(username: String) {
            self.username = username
        }
    }
}
