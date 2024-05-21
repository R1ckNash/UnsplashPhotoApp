//
//  MainPresenter.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func success(photos: [Photo])
    func failure(error: String)
}

protocol MainPresenterProtocol: AnyObject {
    var photos: [Photo]? { get set }
    init(view: MainViewProtocol, networkManager: NetworkManagerProtocol, router: RouterProtocol)
    func fetchPhotos()
    func tapOnPhoto(photo: Photo?)
}

final class MainPresenter: MainPresenterProtocol {
    var photos: [Photo]?
    private weak var view: MainViewProtocol?
    private var router: RouterProtocol
    private let networkManager: NetworkManagerProtocol
    
    required init(view: MainViewProtocol, networkManager: NetworkManagerProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
    }
    
    func fetchPhotos() {
        networkManager.fetchPhotos { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                self?.view?.success(photos: photos)
            case .failure(let error):
                let errorDescription = (error as? NetworkError)?.message ?? error.localizedDescription
                self?.view?.failure(error: errorDescription)
            }
        }
    }
    
    func tapOnPhoto(photo: Photo?) {
        guard let photo = photo else { return }
        router.showDetailViewController(with: photo)
    }
}
