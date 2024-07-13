//
//  ViewModel.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/12/24.
//

import Foundation
import Combine

final class ViewModel: ObservableObject {
    private let photoProvider: PhotosProvider
    private let rover: Rovers
    
    @Published var photoDict: [Int: URL] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    init(for rover: Rovers) {
        self.rover = rover
        self.photoProvider = PhotosProviderImpl(for: rover)
        
        bind()
    }
    
    func bind() {
        photoProvider.fetchPhotos()
            .sink { completion in
                
                guard case .failure(let error) = completion else { return }
            } receiveValue: { [weak self] photos in
                guard let self else { return }
                photoDict = photos
            }
            .store(in: &cancellables)
    }
}
