//
//  MainViewController.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!
    private var dataSource: UITableViewDiffableDataSource<Int, PhotoTableViewCellModel>!
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension
        table.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        table.separatorStyle = .none
        table.backgroundColor = .black
        table.delegate = self
        table.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.reuseIdentifier)
        return table
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
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, PhotoTableViewCellModel>(tableView: tableView) { tableView, indexPath, cellModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.reuseIdentifier, for: indexPath)
            as! PhotoTableViewCell
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

//MARK: - extension UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let photo = dataSource?.itemIdentifier(for: indexPath) {
            presenter.didTapPhoto(id: photo.id)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

//MARK: - extension MainViewProtocol
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
