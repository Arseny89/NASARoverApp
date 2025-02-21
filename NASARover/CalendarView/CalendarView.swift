//
//  CalendarView.swift
//  NASARover
//
//  Created by Арсений Корниенко on 9/1/24.
//

import Foundation
import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var selectedDate: String = ""
    
    
    var body: some View {
        Picker("", selection: $selectedDate) {
            ForEach(viewModel.dates.sorted { $0.value < $1.value }, id: \.value) {data , value in
                
                Text("\(data!)")
            }
        }
        .pickerStyle(.inline)
        .onAppear {
            viewModel.bind()
        }
    }
}

#Preview {
    CalendarView(viewModel: CalendarViewModel(for: .curiosity))
}
