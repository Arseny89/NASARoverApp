//
//  CalendarViewModel.swift
//  NASARover
//
//  Created by Арсений Корниенко on 9/1/24.
//

import Foundation
import SwiftUI
import Combine

final class CalendarViewModel: ObservableObject {
    @Published var selectedRover: Rovers
    @Published var dates: [Date? : Int] = [:]
    private let photoProvider: PhotosProvider
    private var cancellables = Set<AnyCancellable>()

    init(for rover: Rovers) {
        self.photoProvider = PhotosProviderImpl(for: rover)
        self.selectedRover = rover
    }
    
    func bind() {
        photoProvider.getManifestData()
            .sink { completion in
                guard case .failure(_) = completion else { return }
            } receiveValue: { [weak self] data in
                guard let self else { return }
                dates = Dictionary(
                    uniqueKeysWithValues:
                        data.photos.map {
                            (self.getDate(from: $0.earthDate), $0.sol)
                        }
                )
            }
            .store(in: &cancellables)
    }
    
    private func getDate(from: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: from)
    }
}
