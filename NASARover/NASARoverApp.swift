//
//  NASARoverApp.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/5/24.
//

import SwiftUI

@main
struct NASARoverApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel(for: .curiosity))
        }
    }
}
