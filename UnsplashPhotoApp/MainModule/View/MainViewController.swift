//
//  MainViewController.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 17/05/2024.
//

import UIKit

class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
    }
    
    private func showAlert(withTitle title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
}

extension MainViewController: MainViewProtocol {
    func sucess(photos: [Photo]) {
        //updateDataSource(with: photos)
        print(photos)
    }
    
    func failure(error: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showAlert(withTitle: "Error", message: error)
        }
    }
}
