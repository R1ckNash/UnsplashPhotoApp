//
//  PhotoTableViewCell.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 18/05/2024.
//

import UIKit
import Kingfisher


final class PhotoTableViewCell: UITableViewCell {
    
    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        // configure apperence
        //backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoView.kf.cancelDownloadTask()
        photoView.image = nil
        likesLabel.text = nil
        descriptionLabel.text = nil
    }
    
    func configureCell(with photo: PhotoStruct) {
        let url = URL(string: photo.urls.thumb)
        photoView.kf.setImage(with: url)
        
        likesLabel.text = "\(photo.likes) likes"
        descriptionLabel.text = photo.photoDescription
        descriptionLabel.textColor = UIColor(hexString: photo.color)
        backgroundColor = .black
    }
    
    private func setupLayout() {
        contentView.addSubview(photoView)
        contentView.addSubview(likesLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            photoView.heightAnchor.constraint(equalToConstant: 200),
            
            likesLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 8),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

//MARK: - extension UITableViewCell
extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//MARK: - UIColor extension
private extension UIColor {
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
