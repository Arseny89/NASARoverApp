//
//  PhotosProvider.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/7/24.
//

import Foundation

protocol PhotosProvider {
    func fetchPhotos(for rover: Rovers, _ completion: @escaping ([Int: URL]) -> ())
}

final class PhotosProviderImpl: PhotosProvider {
    
    private var dataProvider = APIDataProvider()
    private var manifest: PhotoManifest?
    private var photoCache: [PhotoResponse] = []
    private var photoDataCache: [Int: PhotoData] = [:]
    private var photoUrlCache: [Int: URL] = [:]
    private var currentSolData: Photos?
    private let udStorageManager = UDStorageManager()
    private var favoritePhotoIDs: Set<Int> {
        udStorageManager.object(for: .favoritePhotos) ?? []
    }
    private var currentPage = 1
    func getManifestData(for rover: Rovers) {
        dataProvider.getData(for: .manifests(rover: rover)) { [weak self] (data: ManifestResponse) in
            guard let self else { return }
            self.manifest = data.photoManifest
            currentSolData = manifest?.photos.last
        } errorHandler: {error in
            print(error)
        }
    }
    
    func getRoverPhotos(for rover: Rovers, forSol sol: Int, _ page: Int) {
        dataProvider.getData(for: .photosBySol(sol: sol, rover: rover, page: page)) { [weak self] data in
            guard let self else { return }
            photoCache.append(data)
        } errorHandler: { error in
            print(error.localizedDescription)
        }
    }
    
    func fetchPhotos(for rover: Rovers, _ completion: @escaping ([Int: URL]) -> ()) {
        if manifest != nil {
            getPhotos(for: rover, completion)
        } else {
            dataProvider.getData(for: .manifests(rover: rover)) { [weak self] (data: ManifestResponse) in
                guard let self else { return }
                manifest = data.photoManifest
                currentSolData = manifest?.photos.first(where: {$0.sol == self.manifest?.maxSol})
                getPhotos(for: rover, completion)
            } errorHandler: {error in
            }
        }
    }
    
    func getPhotos(for rover: Rovers, _ completion: @escaping ([Int: URL]) -> ()) {
        guard let currentSolData else { return }
        guard let manifest else { return }
        dataProvider.getData(for: .photosBySol(sol: currentSolData.sol, rover: rover, page: currentPage)) { [weak self] (data: PhotoResponse) in
            guard let self else { return }
            currentPage += 1
            if currentPage > currentSolData.pagesCount {
                currentPage = 1
                self.currentSolData = manifest.photos.last(where: {$0.sol < currentSolData.sol})
            }
            data.photos.forEach {
                self.photoUrlCache[$0.id] = $0.imageURL
            }
            completion(photoUrlCache)
        } errorHandler: { error in
        }
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
