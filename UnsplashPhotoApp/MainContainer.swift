//
//  DIContainer.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 25/05/2024.
//

import Foundation
import UIKit
import Swinject

final class MainContainer {
    static let shared = MainContainer()
    let container = Container()
    
    private init() {
        registerDependencies()
        createPhotosRepository()
    }
    
    private func createPhotosRepository() {
        container.register(JSONDecoder.self) { _ in JSONDecoder() }
            .inObjectScope(.container)
        
        container.register(NetworkManagerProtocol.self) { resolver in
            NetworkManager(jsonDecoder: resolver.resolve(JSONDecoder.self)!)
        }
        .inObjectScope(.container)
        
        container.register(RemoteDataSourceProtocol.self) { resolver in
            RemoteDataSource(networkManager: resolver.resolve(NetworkManagerProtocol.self)!)
        }
        .inObjectScope(.container)
        
        container.register(LocalDataSourceProtocol.self) { _ in LocalDataSource() }
            .inObjectScope(.container)
        
        container.register(RepositoryProtocol.self) { resolver in
            PhotoRepository(
                remote: resolver.resolve(RemoteDataSourceProtocol.self)!,
                local: resolver.resolve(LocalDataSourceProtocol.self)!
            )
        }
        .inObjectScope(.container)
    }
    
    private func registerDependencies() {
        
        container.register(NetworkManagerProtocol.self) { _ in NetworkManager(jsonDecoder: JSONDecoder()) }
            .inObjectScope(.container)
        
        container.register(MainModuleAssemblerProtocol.self) { _ in MainModuleAssembler() }
            .inObjectScope(.container)
        
        container.register(DetailModuleAssemblerProtocol.self) { _ in DetailModuleAssembler() }
            .inObjectScope(.container)
        
        container.register(RouterProtocol.self) { _ in Router() }
            .inObjectScope(.container)
    }
    
    var router: RouterProtocol {
        container.resolve(RouterProtocol.self)!
    }
    
    var mainAssembler: MainModuleAssemblerProtocol {
        container.resolve(MainModuleAssemblerProtocol.self)!
    }
    
    var detailAssembler: DetailModuleAssemblerProtocol {
        container.resolve(DetailModuleAssemblerProtocol.self)!
    }
    
    var photosRepository: RepositoryProtocol {
        container.resolve(RepositoryProtocol.self)!
    }
    
    var networkManager: NetworkManagerProtocol {
        container.resolve(NetworkManagerProtocol.self)!
    }
}
