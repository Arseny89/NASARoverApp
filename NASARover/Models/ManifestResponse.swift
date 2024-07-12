//
//  ManifestResponse.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/7/24.
//

import Foundation

struct ManifestResponse: Decodable {
    let photoManifest: PhotoManifest
}

struct PhotoManifest: Codable {
    let name: String
    let landingDate: String
    let launchDate: String
    let status: String
    let maxSol: Int
    let maxDate: String
    let totalPhotos: Int
    let photos: [Photos]
}

struct Photos: Codable {
    let sol: Int
    let earthDate: String
    let totalPhotos: Int
    let cameras: [Cameras.RawValue]
    var pagesCount: Int {
        var pages = totalPhotos / 25
        pages += totalPhotos % 25 == 0 ? 0 : 1
        return pages
    }
}
