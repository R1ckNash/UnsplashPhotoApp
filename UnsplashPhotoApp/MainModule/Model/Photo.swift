//
//  Photo.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation

struct Photo: Decodable {
    let color: String
    let description: String?
    let alt_description: String
    let likes: Int
    let urls: ImageUrls
    let user: User
    
    struct ImageUrls: Decodable {
        let thumb: String
        let regular: String
    }
    struct User: Decodable {
        let username: String
    }
    
    var photoDescription: String {
        if let description = description {
            return description
        } else {
            return alt_description
        }
    }
}
