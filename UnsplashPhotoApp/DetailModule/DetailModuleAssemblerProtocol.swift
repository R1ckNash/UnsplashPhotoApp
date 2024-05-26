//
//  DetailModuleAssemblerProtocol.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 25/05/2024.
//

import Foundation

import UIKit

protocol DetailModuleAssemblerProtocol {
    func assemble(with photo: PhotoStruct) -> UIViewController
}

final class DetailModuleAssembler: DetailModuleAssemblerProtocol {
    
    private var container: MainContainer {
        MainContainer.shared
    }
    
    func assemble(with photo: PhotoStruct) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, networkManager: container.networkManager, photo: photo)
        view.presenter = presenter
        return view
    }
}
