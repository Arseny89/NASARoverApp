//
//  ContentView.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/5/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        
        ZStack{
            Color($viewModel.photoDict.wrappedValue.isEmpty ? .white : .red)
                .ignoresSafeArea()
        }
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
    ContentView(viewModel: ViewModel(for: .curiosity))
}
