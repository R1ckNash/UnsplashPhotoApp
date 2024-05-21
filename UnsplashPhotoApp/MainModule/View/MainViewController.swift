//
//  MainViewController.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import UIKit

class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!
    var dataSource: UITableViewDiffableDataSource<Int, Photo>!
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.reuseIdentifier)
        //table.estimatedRowHeight = 100
        
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Main Photos"
        setupLayouts()
        setupDataSource()
        presenter.fetchPhotos()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        presenter.fetchPhotos()
//    }
    
    private func setupLayouts() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupDataSource() {
            dataSource = UITableViewDiffableDataSource<Int, Photo>(tableView: tableView) { tableView, indexPath, photo in
                let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.reuseIdentifier, for: indexPath)
                as! PhotoTableViewCell
                cell.configureCell(with: photo)
                return cell
            }
        }
    
    func updateDataSource(with photos: [Photo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
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

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if let photo = dataSource?.itemIdentifier(for: indexPath) {
//            //presenter.tapOnPhoto(photo: photo)
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
    }
}

extension MainViewController: MainViewProtocol {
    func sucess(photos: [Photo]) {
        updateDataSource(with: photos)
        print(photos)
    }
    
    func failure(error: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showAlert(withTitle: "Error", message: error)
        }
    }
}
