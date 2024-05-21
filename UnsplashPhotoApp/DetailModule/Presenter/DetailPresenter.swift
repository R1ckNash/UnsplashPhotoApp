//
//  DetailPresenter.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 21/05/2024.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func configureDetailView(with photo: Photo)
}

protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, networkManager: NetworkManagerProtocol, router: RouterProtocol, photo: Photo)
    func configureDetailView()
}

final class DetailPresenter: DetailViewPresenterProtocol {
    
    weak var view: DetailViewProtocol?
    var router: RouterProtocol?
    let networkManager: NetworkManagerProtocol!
    var photo: Photo
    
    init(view: DetailViewProtocol, networkManager: NetworkManagerProtocol, router: RouterProtocol, photo: Photo) {
        self.view = view
        self.networkManager = networkManager
        self.photo = photo
        self.router = router
    }
    
    func configureDetailView() {
        self.view?.configureDetailView(with: photo)
    }
}
