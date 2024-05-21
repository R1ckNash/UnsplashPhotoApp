//
//  PhotoTableViewCell.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 18/05/2024.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    private lazy var photoView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with photo: Photo) {
        //photoView.image = photo.urls.thumb загрузка изображения из сети
        likesLabel.text = String(photo.likes)
        descriptionLabel.text = photo.description
        //descriptionLabel.textColor = UIColor(hexString: photo.color)
    }
    
    func setupLayout() {
       // contentView.addSubview(photoView)
        contentView.addSubview(likesLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
//            photoView.heightAnchor.constraint(equalToConstant: 60),
//            photoView.widthAnchor.constraint(equalToConstant: 30),
//            photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
//            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            photoView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5),
            
//            likesLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
//            likesLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 16),
//            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
//            
//            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
//            descriptionLabel.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 16),
//            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
        ])
    }

}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//MARK: - UIColor extension

extension UIColor {
    convenience init?(hexString: String) {
        var cString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
