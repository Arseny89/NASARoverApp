//
//  PhotoGalleryViewModel.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/25/24.
//

import Combine
import SwiftUI

final class PhotoGalleryViewModel: ObservableObject {
    @Published var photos: [Int: PhotoData] = [:]
    @Published var detailedURL: URL? = nil
    @Published var presentDetailedView: Bool = false
    @Published var photoData: PhotoData? = nil
    @Published var inFavorites: Bool = false
    private let photoProvider: PhotosProvider
    private let rover: Rovers
    private var cancellables = Set<AnyCancellable>()
    
    init(for rover: Rovers) {
        self.rover = rover
        self.photoProvider = PhotosProviderImpl(for: rover)
        bind()
    }
    
    func bind() {
        photoProvider.fetchPhotos()
            .sink { completion in
                guard case .failure(_) = completion else { return }
            } receiveValue: { [weak self] photoData in
                guard let self else { return }
                photos = photoData
            }
            .store(in: &cancellables)
    }
    
    func fetchImage(for data: PhotoData, completion: @escaping (UIImage?) -> Void) {
        downloadImage(from: data.imageURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self else { return }
                if let image = image {
                    DataCacheManager.cache.setObject(object: image, for: String(data.id))
                    objectWillChange.send()
                }
                completion(image)
            }
            .store(in: &cancellables)
    }
    
    func getCachedImage(for key: String) -> UIImage? {
        return DataCacheManager.cache.getObject(for: key) as? UIImage
    }
    
    private func downloadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
