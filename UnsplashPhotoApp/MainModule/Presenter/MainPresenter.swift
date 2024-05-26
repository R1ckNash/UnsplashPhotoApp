//
//  MainPresenter.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func success(photos: [PhotoStruct])
    func failure(error: String)
}

protocol MainPresenterProtocol: AnyObject {
    var photos: [PhotoStruct]? { get set }
    func viewWillAppear()
    func didTapPhoto(photo: PhotoStruct?)
}

final class MainPresenter: MainPresenterProtocol {
    var photos: [PhotoStruct]?
    private weak var view: MainViewProtocol?
    private var router: RouterProtocol
    private let networkManager: NetworkManagerProtocol
    private let photosRepository: RepositoryProtocol
    
    init(view: MainViewProtocol, router: RouterProtocol, networkManager: NetworkManagerProtocol, photosRepository: RepositoryProtocol) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
        self.photosRepository = photosRepository
    }
    
    func viewWillAppear() {
        //view set state loading
        fetchPhotos()
        // set content
    }
    
    private func fetchPhotos() {
        photosRepository.fetch { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self.photos = photos
                    self.view?.success(photos: photos)
                case .failure(let error):
                    self.view?.failure(error: error.localizedDescription)
                }
            }
        }
    }
    
    func didTapPhoto(photo: PhotoStruct?) { // сюда придет не фото сюда бы передать id и вытащить ее из массива // общаться индексами или айдишниками
        guard let photo = photo else { return }
        //найти по айдишнику фото в репозитории
        router.showDetailViewController(with: photo)
    }
}

// PhotoTableViewCell Model     вью модель
// из серверной модели в доменную мапит репозиторий(нетворк менеджер в моем случае), презентер перегоняет из доменной во вью модель
//
