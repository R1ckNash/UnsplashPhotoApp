//
//  AssemblyModuleBuilder.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation
import UIKit

protocol AssemblyModuleBuilderProtocol {
    func buildMainModule(router: RouterProtocol) -> UIViewController
    func buildDetailModule(with photo: Photo, router: RouterProtocol) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    
    func buildMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkManager = NetworkManager()
        let presenter = MainPresenter(view: view, networkManager: networkManager, router: router)
        view.presenter = presenter
        return view
    }
    
    func buildDetailModule(with photo: Photo, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let networkManager = NetworkManager()
        let presenter = DetailPresenter(view: view, networkManager: networkManager, router: router, photo: photo)
        view.presenter = presenter
        return view
    }
}
