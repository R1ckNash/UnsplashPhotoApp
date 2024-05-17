//
//  MainPresenter.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func sucess(photos: [Photo])
    func failure(error: String)
}

protocol MainPresenterProtocol: AnyObject {
    var photos: [Photo]? { get set }
    init(view: MainViewProtocol, networkManager: NetworkManagerProtocol, router: RouterProtocol)
    func fetchPhotos()
    func tapOnPhoto(photo: Photo?)
}

class MainPresenter: MainPresenterProtocol {
    var photos: [Photo]?
    weak var view: MainViewProtocol?
    var router: RouterProtocol
    let networkManager: NetworkManagerProtocol
    
    required init(view: MainViewProtocol, networkManager: NetworkManagerProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
        fetchPhotos()
    }
    
    func fetchPhotos() {
        networkManager.fetchPhotos { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                self?.view?.sucess(photos: photos)
            case .failure(let error):
                let errorDescription = (error as? NetworkError)?.message ?? error.localizedDescription
                self?.view?.failure(error: errorDescription)
            }
        }
    }
    
    func tapOnPhoto(photo: Photo?) {
        guard let photo = photo else { return }
        router.showDetail(with: photo)
    }
    
    
}
