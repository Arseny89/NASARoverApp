//
//  ViewModel.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/12/24.
//

import Combine

final class RoverSelectionViewModel: ObservableObject {
    @Published var selectedRover: Rovers = .curiosity
    private let photoProvider: PhotosProvider
    private let rover: Rovers
    private var cancellables = Set<AnyCancellable>()
    
    init(for rover: Rovers) {
        self.rover = rover
        self.photoProvider = PhotosProviderImpl(for: rover)
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
