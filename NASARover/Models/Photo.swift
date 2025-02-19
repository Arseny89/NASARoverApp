//
//  Photo.swift
//  NASARover
//
//  Created by Арсений Корниенко on 8/6/24.
//

import SwiftUI
import SwiftData

@Model
final class Photo {
    @Attribute(.unique)
    var id: UUID
    var data: Data
    var photoDataRaw: Data?
    
    var photoData: PhotoData? {
            get {
                guard let rawData = photoDataRaw else { return nil }
                return try? JSONDecoder().decode(PhotoData.self, from: rawData)
            }
            set {
                photoDataRaw = try? JSONEncoder().encode(newValue)
            }
        }

    init(id: UUID, data: Data, photoData: PhotoData) {
        self.id = id
        self.data = data
        self.photoData = photoData
    }
}
