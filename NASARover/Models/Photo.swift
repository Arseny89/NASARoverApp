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
    var rover: String
    @Attribute(.unique)
    var url: URL
    var data: Data
    var date: String
    var sol: Int
    var camera: String
    
    @Transient
    var image: Image {
        guard let uiImage = UIImage(data: data) else {return Image(icon: .xmark)}
        return Image(uiImage: uiImage)
    }
    
    init(rover: String, url: URL, data: Data, date: String, sol: Int, camera: String) {
        self.rover = rover
        self.url = url
        self.data = data
        self.date = date
        self.sol = sol
        self.camera = camera
    }
}
