//
//  DetailModuleAssemblerProtocol.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 25/05/2024.
//

import Foundation

import UIKit

protocol DetailModuleAssemblerProtocol {
    func assemble(with detailModel: DetailViewModel) -> UIViewController
}

final class DetailModuleAssembler: DetailModuleAssemblerProtocol {
    
    private var container: MainContainer {
        MainContainer.shared
    }
    
    func assemble(with detailModel: DetailViewModel) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, detailModel: detailModel)
        view.presenter = presenter
        return view
    }
}
