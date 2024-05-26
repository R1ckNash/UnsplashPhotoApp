//
//  DetailViewController.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 21/05/2024.
//

import UIKit

final class DetailViewController: UIViewController {
    
    var presenter: DetailViewPresenterProtocol!
    
    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupLayout()
        presenter.configureDetailView()
    }
    
    func setupLayout() {
        view.addSubview(photoView)
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - extension DetailViewProtocol
extension DetailViewController: DetailViewProtocol {
    func configureDetailView(with photo: PhotoStruct) {
        navigationItem.title = photo.user.username
        
        let url = URL(string: photo.urls.regular)
        photoView.kf.setImage(with: url)
    }
}
