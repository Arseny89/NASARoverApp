//
//  PhotosProvider.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/7/24.
//

import Foundation
import Combine

protocol PhotosProvider {
    func fetchPhotos() -> AnyPublisher<[Int: PhotoData], AppError>
    func getManifestData() -> AnyPublisher<PhotoManifest, AppError>
}

final class PhotosProviderImpl: PhotosProvider {

    private var dataProvider = APIDataProvider()
    private var manifest: PhotoManifest?
    private var photoCache: [PhotoResponse] = []
    private var photoDataCache: [Int: PhotoData] = [:]
    private var currentSolData: Photos?
    private let udStorageManager = UDStorageManager()
    private var favoritePhotoIDs: Set<Int> {
        udStorageManager.object(for: .favoritePhotos) ?? []
    }
    private var currentPage = 1
    var rover: Rovers
    
    init(for rover: Rovers) {
        self.rover = rover
    }
    
    func getManifestData() -> AnyPublisher<PhotoManifest, AppError> {
        if let manifest {
            return Just(manifest)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        } else {
            return dataProvider.request(for: .manifests(rover: rover))
                .map { (response: ManifestResponse) in
                    return response.photoManifest
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func getRoverPhotos() -> AnyPublisher<PhotoResponse, AppError> {
        guard let currentSolData else {
            return Fail(error: AppError.other("SolData invalid"))
                .eraseToAnyPublisher()
        }
        return dataProvider.request(for: .photosBySol(sol: currentSolData.sol, rover: rover, page: currentPage))
    }
    
    func fetchPhotos() -> AnyPublisher<[Int: PhotoData], AppError> {
        return getManifestData()
            .flatMap { [weak self] manifest -> AnyPublisher<[Int: PhotoData], AppError> in
                guard let self else {
                    return Fail(error: AppError.unknown)
                        .eraseToAnyPublisher()
                }
                self.manifest = manifest
                if currentSolData == nil {
                    currentSolData = manifest.photos.first(where: {$0.sol == self.manifest?.maxSol})
                }
                return getRoverPhotos()
                    .flatMap { response -> AnyPublisher<[Int: PhotoData], AppError> in
                        self.currentPage += 1
                        if let currentSolData = self.currentSolData,
                           self.currentPage > currentSolData.pagesCount {
                            self.currentPage = 1
                            self.currentSolData = manifest.photos.last(where: {$0.sol < currentSolData.sol})
                        }
                        response.photos.forEach {
                            self.photoDataCache[$0.id] = $0.self
                        }
                        return Just(self.photoDataCache)
                        
                            .setFailureType(to: AppError.self)
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func addToFavorite(_ photo: PhotoData) {
        var favoritePhotoIDs = favoritePhotoIDs
        favoritePhotoIDs.insert(photo.id)
        udStorageManager.set(object: favoritePhotoIDs, key: .favoritePhotos)
    }
    
    func removeFromFavorite(_ photo: PhotoData) {
        var favoritePhotoIDs = favoritePhotoIDs
        favoritePhotoIDs.remove(photo.id)
        udStorageManager.set(object: favoritePhotoIDs, key: .favoritePhotos)
    }
}
