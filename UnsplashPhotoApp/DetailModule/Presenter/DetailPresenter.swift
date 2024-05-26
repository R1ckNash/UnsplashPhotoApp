//
//  DetailPresenter.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 21/05/2024.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func configureDetailView(with photo: PhotoStruct)
}

protocol DetailViewPresenterProtocol: AnyObject {
    func configureDetailView()
}

final class DetailPresenter: DetailViewPresenterProtocol {
    
    weak var view: DetailViewProtocol?
    let networkManager: NetworkManagerProtocol!
    var photo: PhotoStruct
    
    init(view: DetailViewProtocol, networkManager: NetworkManagerProtocol, photo: PhotoStruct) {
        self.view = view
        self.networkManager = networkManager
        self.photo = photo
    }
    
    func configureDetailView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.configureDetailView(with: self.photo)
        }
    }
}
