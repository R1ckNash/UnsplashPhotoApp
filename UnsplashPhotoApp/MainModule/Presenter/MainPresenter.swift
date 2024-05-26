//
//  MainPresenter.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func configure(with model: MainViewController.MainScreenState)
}

protocol MainPresenterProtocol: AnyObject {
    var photos: [PhotoStruct]? { get set }
    func viewWillAppear()
    func didTapPhoto(id: String)
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
        view?.configure(with: .loading)
        fetchPhotos()
    }
    
    private func fetchPhotos() {
        photosRepository.fetch { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self.photos = photos
                    self.view?.configure(with: .content(MainViewModelContent(title: "Photos", cellModels: self.mapToCellModels(from: photos))))
                case .failure(let error):
                    self.view?.configure(with: .error(error.localizedDescription))
                }
            }
        }
    }
    
    func didTapPhoto(id: String) {
        guard let photo = (photos?.first { $0.id == id }) else { return }
        router.showDetailViewController(with: mapToDetailViewModel(from: photo))
    }
    
    //MARK: - Mappers
    
    private func mapToDetailViewModel(from photo: PhotoStruct) -> DetailViewModel {
        return DetailViewModel(photoUrl: photo.urls.regular, authorName: photo.user.username)
    }
    
    private func mapToCellModel(from photo: PhotoStruct) -> PhotoTableViewCellModel {
        return PhotoTableViewCellModel(id: photo.id, photoUrl: photo.urls.thumb, likes: photo.likes, description: photo.photoDescription, color: photo.color)
    }
    
    private func mapToCellModels(from photos: [PhotoStruct]) -> [PhotoTableViewCellModel] {
        return photos.map { mapToCellModel(from: $0) }
    }
}
