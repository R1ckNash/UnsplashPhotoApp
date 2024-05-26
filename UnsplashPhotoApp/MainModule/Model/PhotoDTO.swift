//
//  PhotoDTO.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 26/05/2024.
//

import Foundation

class PhotoDTO: NSObject, Decodable {
    let color: String
    let desc: String?
    let altDescription: String
    let likes: Int
    let urls: ImageUrls
    let user: User
    
    init(color: String, desc: String?, altDescription: String, likes: Int, urls: ImageUrls, user: User) {
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
    
    class ImageUrls: NSObject, Decodable {
        let thumb: String
        let regular: String
        
        init(thumb: String, regular: String) {
            self.thumb = thumb
            self.regular = regular
        }
    }
    
    class User: NSObject, Decodable {
        let username: String
        
        init(username: String) {
            self.username = username
        }
    }
}
