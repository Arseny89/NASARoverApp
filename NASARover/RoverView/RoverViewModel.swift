//
//  RoverViewModel.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/17/24.
//

import Foundation
import Combine

final class RoverViewModel: ObservableObject {
    @Published var manifest: [PhotoManifest] = []
    @Published var selectedRover: Rovers
    @Published var totalPhotos: Int = 0
    @Published var maxDate: String = "--"
    @Published var maxSol: Int = 0
    private let photoProvider: PhotosProvider
    private var cancellables = Set<AnyCancellable>()
    
    init(for rover: Rovers) {
        self.selectedRover = rover
        self.photoProvider = PhotosProviderImpl(for: rover)
        }
    
    func bind() {
        photoProvider.getManifestData()
            .sink { completion in
                guard case .failure(_) = completion else { return }
            } receiveValue: { [weak self] data in
                guard let self else { return }
                totalPhotos = data.totalPhotos
                maxDate = data.maxDate
                maxSol = data.maxSol
            }
            .store(in: &cancellables)
    }
}
