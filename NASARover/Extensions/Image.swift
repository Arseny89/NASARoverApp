//
//  Image.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/16/24.
//

import Foundation
import SwiftUI

extension Image {
    
    init(icon: Icons) {
        self.init(systemName: icon.rawValue)
    }
    
    init(image: Images) {
        self.init(image.rawValue)
    }
    
    enum Icons: String {
        case ellipsisCircle = "ellipsis.circle"
        case calendar = "calendar"
        case xmark = "xmark"
        case add = "plus"
        case heart = "heart.fill"
        case trash = "trash"
        case checkmarkSquare = "checkmark.square.fill"
        case square = "square.fill"
        case download = "square.and.arrow.down"
    }
    
    enum Images: String {
        case curiosity = "curiosity_shape_bg"
        case opportunity = "opportunity_shape_bg"
        case spirit = "spirit_shape_bg"
    }
}
