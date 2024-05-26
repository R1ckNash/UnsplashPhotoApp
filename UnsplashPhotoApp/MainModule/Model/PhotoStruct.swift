//
//  Photo.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation

struct PhotoStruct: Decodable, Hashable {
    let color: String
    let description: String?
    let alt_description: String
    let likes: Int
    let urls: ImageUrls
    let user: User
    
    struct ImageUrls: Decodable, Hashable {
        let thumb: String
        let regular: String
    }
    struct User: Decodable, Hashable {
        let username: String
    }
    
    var photoDescription: String {
        return description ?? alt_description
    }
}
