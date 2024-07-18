//
//  ViewModel.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/12/24.
//

import Foundation
import Combine

final class RoverSelectionViewModel: ObservableObject {
    @Published var photoDict: [Int: URL] = [:]
    @Published var selectedRover: Rovers = .curiosity
    private let photoProvider: PhotosProvider
    private let rover: Rovers
    private var cancellables = Set<AnyCancellable>()
    
    init(for rover: Rovers) {
        self.rover = rover
        self.photoProvider = PhotosProviderImpl(for: rover)
    }
    
    func bind() {
        photoProvider.fetchPhotos()
            .sink { completion in
                guard case .failure(_) = completion else { return }
            } receiveValue: { [weak self] photos in
                guard let self else { return }
                photoDict = photos
            }
            .store(in: &cancellables)
    }
    
    func getMissionInfo(for rover: Rovers) -> String {
        switch rover {
        case .curiosity:
            return String(localized: "CuriosityMissionInfo")
        case .opportunity:
            return String(localized: "OpportunityMissionInfo")
        case .spirit:
            return String(localized: "SpiritMissionInfo")
        }
    }
}
