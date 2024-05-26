//
//  PhotoTableViewCellModel.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 26/05/2024.
//

import Foundation

struct PhotoTableViewCellModel: Hashable {
    let id: String
    let photoUrl: String
    let likes: Int
    let description: String
    let color: String
}
