//
//  PhotoResponse.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/7/24.
//

import Foundation

struct PhotoResponse: Decodable {
    let photos: [PhotoData]
}

struct RoverInfo: Decodable {
    let name: String
}

struct PhotoData: Decodable {
    let rover: RoverInfo
    let id: Int
    let sol: Int
    let imageURL: URL
    let date: String
    let camera: Camera
    
    enum CodingKeys: String, CodingKey {
        case rover
        case id
        case sol
        case imageSource = "imgSrc"
        case date = "earthDate"
        case camera
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.sol = try container.decode(Int.self, forKey: .sol)
        let imageSource = try container.decode(URL.self, forKey: .imageSource)
        self.imageURL = URL(string: "\(imageSource)") ?? URL.homeDirectory
        self.date = try container.decode(String.self, forKey: .date)
        self.camera = try container.decode(Camera.self, forKey: .camera)
        self.rover = try container.decode(RoverInfo.self, forKey: .rover)
    }
}

struct Camera: Decodable {
    let fullName: String
}
