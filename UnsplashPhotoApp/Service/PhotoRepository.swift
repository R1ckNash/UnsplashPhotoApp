//
//  PhotoRepository.swift
//  UnsplashPhotoApp
//
//  Created by Ilia Liasin on 25/05/2024.
//

import Foundation

protocol RepositoryProtocol {
    func fetch(completion: @escaping (Result<[PhotoStruct], NetworkError>) -> Void)
    func fetchWithCancellation(completion: @escaping (Result<[PhotoStruct], NetworkError>) -> Void)
}

final class PhotoRepository: RepositoryProtocol {
    let remote: RemoteDataSourceProtocol
    let local: LocalDataSourceProtocol
    private var currentRequest: RunningRequest?
    
    init(remote: RemoteDataSourceProtocol, local: LocalDataSourceProtocol) {
        self.remote = remote
        self.local = local
    }
    
    func fetch(completion: @escaping (Result<[PhotoStruct], NetworkError>) -> Void) {
        local.fetchPhotos { [weak self] cachedPhotos in
            guard let self = self else { return }
            if let photos = cachedPhotos {
                completion(.success(self.mapToStructs(from: photos)))
            } else {
                self.remote.fetchPhotos { result in
                    switch result {
                    case .success(let photos):
                        self.local.savePhotos(self.mapToDTOs(from: photos))
                        completion(.success(photos))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func fetchWithCancellation(completion: @escaping (Result<[PhotoStruct], NetworkError>) -> Void) {
        currentRequest = remote.fetchPhotosWithCancellation { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                self.local.savePhotos(self.mapToDTOs(from: photos))
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancelFetch() {
        currentRequest?.cancel()
        currentRequest = nil
    }
    
    //MARK: - Mappers
    
    private func mapToDTO(from photoStruct: PhotoStruct) -> PhotoDTO {
        let imageUrls = PhotoDTO.ImageUrls(thumb: photoStruct.urls.thumb, regular: photoStruct.urls.regular)
        let user = PhotoDTO.User(username: photoStruct.user.username)
        return PhotoDTO(
            id: photoStruct.id,
            color: photoStruct.color,
            desc: photoStruct.description,
            altDescription: photoStruct.alt_description,
            likes: photoStruct.likes,
            urls: imageUrls,
            user: user)
    }
    
    private func mapToDTOs(from photoStructs: [PhotoStruct]) -> [PhotoDTO] {
        return photoStructs.map { mapToDTO(from: $0) }
    }
    
    private func mapToStruct(from photoDTO: PhotoDTO) -> PhotoStruct {
        let imageUrls = PhotoStruct.ImageUrls(thumb: photoDTO.urls.thumb, regular: photoDTO.urls.regular)
        let user = PhotoStruct.User(username: photoDTO.user.username)
        return PhotoStruct(
            id: photoDTO.id,
            color: photoDTO.color,
            description: photoDTO.desc,
            alt_description: photoDTO.altDescription,
            likes: photoDTO.likes,
            urls: imageUrls,
            user: user
        )
    }
    
    private func mapToStructs(from photoDTOs: [PhotoDTO]) -> [PhotoStruct] {
        return photoDTOs.map { mapToStruct(from: $0) }
    }
}
