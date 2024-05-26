//
//  AssemblyModuleBuilder.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation
import UIKit

protocol MainModuleAssemblerProtocol {
    func assemble() -> UIViewController
}

final class MainModuleAssembler: MainModuleAssemblerProtocol {
    
    private var container: MainContainer {
        MainContainer.shared
    }
    
    func assemble() -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter(view: view,
                                      router: container.router,
                                      networkManager: container.networkManager,
                                      photosRepository: container.photosRepository)
        view.presenter = presenter
        return view
    }
}
