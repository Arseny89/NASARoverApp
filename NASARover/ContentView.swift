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
        ZStack {
            Color($viewModel.photoDict.wrappedValue.isEmpty ? .white : .red)
                .ignoresSafeArea()
        }
        .onAppear {
            viewModel.bind()
        }
    }
}

#Preview {
    ContentView(viewModel: ViewModel(for: .curiosity))
}
