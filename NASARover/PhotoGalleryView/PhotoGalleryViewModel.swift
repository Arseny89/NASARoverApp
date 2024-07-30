//
//  PhotoGalleryViewModel.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/25/24.
//

import Combine
import SwiftUI

final class PhotoGalleryViewModel: ObservableObject {
    @Published var photos: [Int: URL] = [:]
    @Published var detailedURL: URL? = nil
    @Published var presentDetailedView: Bool = false
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
            } receiveValue: { [weak self] photoURL in
                guard let self else { return }
                photos = photoURL
            }
            .store(in: &cancellables)
    }
}
