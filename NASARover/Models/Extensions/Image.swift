//
//  Image.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/16/24.
//

import Foundation
import SwiftUI

extension Image {
    
    init?(icon: Icons) {
        self.init(systemName: icon.rawValue)
    }
    
    init?(image: Images) {
        self.init(systemName: image.rawValue)
    }
    
    enum Icons: String {
        case ellipsisCircle = "ellipsis.circle"
        case calendar = "calendar"
    }
    
    enum Images: String {
        case curiosity = "curiosity_shape_bg"
        case opportunity = "opportunity_shape_bg"
        case spirit = "spirit_shape_bg"
    }
}
