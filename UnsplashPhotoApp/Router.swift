//
//  Router.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation
import UIKit
import Swinject

protocol RouterProtocol {
    func startInitialFlow(with window: UIWindow?)
    func initialViewController()
    func showDetailViewController(with photo: PhotoStruct)
}

final class Router: RouterProtocol {
    var navigationController: UINavigationController
    
    private var container: MainContainer {
        MainContainer.shared
    }
    
    init() {
        self.navigationController = UINavigationController()
    }
    
    func startInitialFlow(with window: UIWindow?) {
        initialViewController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func initialViewController() {
        let mainViewController = container.mainAssembler.assemble()
        navigationController.viewControllers = [mainViewController]
    }
    
    func showDetailViewController(with photo: PhotoStruct) {
        let detailViewController = container.detailAssembler.assemble(with: photo)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
