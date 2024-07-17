//
//  Rovers.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/5/24.
//

import Foundation

enum Rovers: String, CaseIterable {
    case curiosity
    case opportunity
    case spirit
}

enum Cameras: String {
    case fhaz = "FHAZ"
    case rhaz = "RHAZ"
    case mast = "MAST"
    case chemcam = "CHEMCAM"
    case mahli = "MAHLI"
    case mardi = "MARDI"
    case navcam = "NAVCAM"
    case pancam = "PANCAM"
    case minites = "MINITES"
    
    var description: String {
        switch self {
        case .fhaz: return "Front Hazard Avoidance Camera"
        case .rhaz: return "Rear Hazard Avoidance Camera"
        case .mast: return "Mast Camera"
        case .chemcam: return "Chemistry and Camera Complex"
        case .mahli: return "Mars Hand Lens Imager"
        case .mardi: return "Mars Descent Imager"
        case .navcam: return "Navigation Camera"
        case .pancam: return "Panoramic Camera"
        case .minites: return "Miniature Thermal Emission Spectrometer"
            
        }
    }
}
    
    func getMissionInfo(for rover: Rovers) -> String {
        switch rover {
        case .curiosity:
            return "Part of NASA's Mars Science Laboratory mission, Curiosity, was the largest and most capable rover ever sent to Mars when it launched in 2011. Curiosity set out to answer the question: Did Mars ever have the right environmental conditions to support small life forms called microbes? Early in its mission, Curiosity's scientific tools found chemical and mineral evidence of past habitable environments on Mars. It continues to explore the rock record from a time when Mars could have been home to microbial life."
        case .opportunity:
            return "NASA's Opportunity rover was one of the most successful and enduring interplanetary missions. Opportunity landed on Mars in early 2004 soon after its twin rover Spirit. Opportunity operated for almost 15 years, setting several records and making a number of key discoveries."
        case .spirit:
            return "The Spirit and Opportunity rovers together represented NASA's Mars Exploration Rover Mission (MER), part of the Mars Exploration Program. Launched about a month apart in 2003, the twin rovers’ main scientific objective was to search for a range of rocks and soil types and then look for clues for past water activity on Mars."
        }
    }

