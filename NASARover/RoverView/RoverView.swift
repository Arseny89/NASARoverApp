//
//  RoverView.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/17/24.
//

import SwiftUI

struct RoverView: View {
    @ObservedObject var viewModel: RoverViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var presentSheet = true
    @State var minSheetHeight = 100
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        HStack {
                            Text($viewModel.rover.wrappedValue.rawValue.uppercased())
                                .font(.system(size: 28, weight: .bold))
                                .shadow(1, offset: 5.0, angle: .bottomTrailing)
                                .foregroundColor(.white)
                                .padding(20)
                                .safeAreaPadding(.top, 30)
                            Spacer()
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(icon: .xmark)?
                                    .resizable()
                                    .scaledToFill()
                                    .frame(20)
                                    .foregroundColor(.white)
                                    .shadow(1, offset: 5.0, angle: .bottomTrailing)
                                
                            }
                            .padding(20)
                            .safeAreaPadding(.top, 30)
                        }
                        Spacer()
                        HStack {
                            VStack {
                                Text("\($viewModel.maxDate.wrappedValue)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold))
                                    .safeAreaPadding(.leading, 30)
                                    .lineLimit(1)
                                
                                Text(Titles.maxDate.rawValue.capitalized)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .semibold))
                                    .safeAreaPadding(.bottom, CGFloat(minSheetHeight) + 40)
                                    .safeAreaPadding(.leading, 30)
                            }
                            Spacer()
                            VStack {
                                Text("\($viewModel.maxSol.wrappedValue)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold))
                                    .safeAreaPadding(.leading, 30)
                                    .lineLimit(1)
                                
                                Text(Titles.maxSol.rawValue.capitalized)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .semibold))
                                    .safeAreaPadding(.bottom, CGFloat(minSheetHeight) + 40)
                                    .safeAreaPadding(.leading, 30)
                            }
                            Spacer()
                            VStack {
                                Text("\($viewModel.totalPhotos.wrappedValue)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold))
                                    .safeAreaPadding(.trailing, 30)
                                    .lineLimit(1)
                                
                                Text(Titles.totalPhotos.rawValue.capitalized)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .semibold))
                                    .safeAreaPadding(.bottom, CGFloat(minSheetHeight) + 40)
                                    .safeAreaPadding(.trailing, 30)
                            }
                        }
                    }
                    .frame(UIScreen.width, UIScreen.height)
                    .background {
                        Image("\($viewModel.rover.wrappedValue.rawValue)_bg")
                            .resizable()
                            .scaledToFill()
                    }
                }
                .ignoresSafeArea()
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $presentSheet) {
            Text("Photo Gallery")
                .presentationDetents([.height(CGFloat(minSheetHeight)), .fraction(0.80)])
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    RoverView(viewModel: RoverViewModel(for: .opportunity))
}
