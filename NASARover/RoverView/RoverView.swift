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
    @State var minSheetHeight = 100
    @State var galleryViewHeight: CGFloat = UIScreen.height * 0.1
    @State var lastHeight: CGFloat = UIScreen.height * 0.1
    
    var body: some View {
        NavigationStack {
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
                                Image(icon: .xmark)
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
                                    .safeAreaPadding(.bottom, galleryViewHeight + 50)
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
                                    .safeAreaPadding(.bottom, galleryViewHeight + 50)
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
                                    .safeAreaPadding(.bottom, galleryViewHeight + 50)
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
                .scrollDisabled(true)
                .ignoresSafeArea()
                PhotoGalleryView()
                    .height(galleryViewHeight)
                    .gesture(dragGesture)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PhotoGalleryView: View {
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: UIScreen.width * 0.3, height: 5)
                .clipShape(.capsule)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
}

extension RoverView {
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in
                if galleryViewHeight >= UIScreen.height * 0.1 {
                    galleryViewHeight = lastHeight - value.translation.y
                    galleryViewHeight = max(galleryViewHeight, UIScreen.height * 0.1)
                    if galleryViewHeight >= UIScreen.height * 0.7 {
                        galleryViewHeight = min(galleryViewHeight, UIScreen.height * 0.7)
                    }
                }
            }
            .onEnded {_ in
                lastHeight = galleryViewHeight
            }
    }
}

#Preview {
    RoverView(viewModel: RoverViewModel(for: .opportunity))
}
