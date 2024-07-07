//
//  ContentView.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/5/24.
//

import SwiftUI

struct ContentView: View {
   let apiDataProvider = APIDataProvider()
    
    init() {
        apiDataProvider.getData(for: .manifests(rover: .curiosity)){ (data: Data) in
        } errorHandler: {error in
        }
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
