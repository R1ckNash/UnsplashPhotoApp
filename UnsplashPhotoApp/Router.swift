//
//  Router.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation
import UIKit

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyModuleBuilderProtocol? { get set }
    func initialViewController()
    func showDetailViewController(with photo: Photo)
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyModuleBuilderProtocol?
    
    init(navigationController: UINavigationController? = nil, assemblyBuilder: AssemblyModuleBuilderProtocol? = nil) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        guard let navigationController = navigationController else { return }
        guard let mainViewController = assemblyBuilder?.buildMainModule(router: self) else { return }
        navigationController.viewControllers = [mainViewController]
    }
    
    func showDetailViewController(with photo: Photo) {
        guard let navigationController = navigationController else { return }
        guard let detailViewController = assemblyBuilder?.buildDetailModule(with: photo, router: self) else { return }
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
