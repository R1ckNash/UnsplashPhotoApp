//
//  DetailPresenter.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 21/05/2024.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func configureDetailView(with detailModel: DetailViewModel)
}

protocol DetailViewPresenterProtocol: AnyObject {
    func configureDetailView()
}

final class DetailPresenter: DetailViewPresenterProtocol {
    
    weak var view: DetailViewProtocol?
    var detailModel: DetailViewModel
    
    init(view: DetailViewProtocol, detailModel: DetailViewModel) {
        self.view = view
        self.detailModel = detailModel
    }
    
    func configureDetailView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.configureDetailView(with: self.detailModel)
        }
    }
}
