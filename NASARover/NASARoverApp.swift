//
//  NASARoverApp.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/5/24.
//

import SwiftUI
import SwiftData

@main
struct NASARoverApp: App {
    
    let modelContainer: ModelContainer
        
        init() {
            do {
                modelContainer = try ModelContainer(for: Photo.self)
            } catch {
                fatalError("Could not initialize ModelContainer")
            }
        }
    var body: some Scene {
        WindowGroup {
            RoverSelectionView(viewModel: RoverSelectionViewModel(for: .curiosity))
                .modelContainer(modelContainer)
        }
    }
}
