//
//  MainViewController.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!
    private var dataSource: UICollectionViewDiffableDataSource<Int, PhotoTableViewCellModel>!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarAppearance()
        setupLayouts()
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupLayouts() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, PhotoTableViewCellModel>(collectionView: collectionView) { collectionView, indexPath, cellModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
            cell.configureCell(with: cellModel)
            return cell
        }
    }
    
    private func updateDataSource(with photos: [PhotoTableViewCellModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoTableViewCellModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(photos)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - extension UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let photo = dataSource?.itemIdentifier(for: indexPath) {
            presenter.didTapPhoto(id: photo.id)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 300)
    }
}

//MARK: - MainViewProtocol conformance
extension MainViewController: MainViewProtocol {
    
    enum MainScreenState {
        case initial
        case loading
        case content(MainViewModelContent)
        case error(String)
    }
    
    func configure(with model: MainScreenState) {
        switch model {
        case .initial:
            break
            
        case .loading:
            let loadingIndicator = UIActivityIndicatorView(style: .large)
            loadingIndicator.center = view.center
            loadingIndicator.color = .white
            loadingIndicator.startAnimating()
            view.addSubview(loadingIndicator)
            
        case .content(let modelContent):
            navigationItem.title = modelContent.title
            updateDataSource(with: modelContent.cellModels)
            view.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
            
        case .error(let errorMessage):
            showAlert(withTitle: "Error", message: errorMessage)
            view.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
        }
    }
}
