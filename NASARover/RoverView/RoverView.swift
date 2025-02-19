//
//  RoverView.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/17/24.
//

import SwiftUI
import SwiftData

struct RoverView: View {
    @StateObject var viewModel: RoverViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var minSheetHeight = 100
    @State var galleryViewHeight: CGFloat = UIScreen.height * 0.2
    @State var lastHeight: CGFloat = UIScreen.height * 0.2
    @State var currentHeight: CGFloat = 0.0
    @State var photoGalleryView: PhotoGalleryView
    
    init(rover: Rovers, photoGalleryView: PhotoGalleryView) {
        self._viewModel = StateObject(wrappedValue: RoverViewModel(for: rover))
        self.photoGalleryView = photoGalleryView
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        HStack {
                            Text($viewModel.selectedRover.wrappedValue.rawValue.uppercased())
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
                                    .font(.system(size: 18, weight: .bold))
                                    .safeAreaPadding(.leading, 30)
                                    .lineLimit(1)
                                
                                Text(Titles.maxDate.rawValue.capitalized)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .semibold))
                                    .safeAreaPadding(.bottom, galleryViewHeight + 10)
                                    .safeAreaPadding(.leading, 30)
                            }
                            Spacer()
                            VStack {
                                Text("\($viewModel.maxSol.wrappedValue)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                                    .safeAreaPadding(.leading, 30)
                                    .lineLimit(1)
                                
                                Text(Titles.maxSol.rawValue.capitalized)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .semibold))
                                    .safeAreaPadding(.bottom, galleryViewHeight + 10)
                                    .safeAreaPadding(.leading, 30)
                            }
                            Spacer()
                            VStack {
                                Text("\($viewModel.totalPhotos.wrappedValue)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                                    .safeAreaPadding(.trailing, 30)
                                    .lineLimit(1)
                                
                                Text(Titles.totalPhotos.rawValue.capitalized)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .semibold))
                                    .safeAreaPadding(.bottom, galleryViewHeight + 10)
                                    .safeAreaPadding(.trailing, 30)
                            }
                        }
                    }
                    .frame(UIScreen.width, UIScreen.height)
                }
                .scrollDisabled(true)
                photoGalleryView
                    .frame(UIScreen.width, $galleryViewHeight.wrappedValue)
                    .gesture(dragGesture)
                    .backgroundColor(.white.opacity(0.9))
                    .clipShape(.rect (topLeadingRadius: 20,
                                      topTrailingRadius: 20))
            }
            .background {
                Image("\($viewModel.selectedRover.wrappedValue.rawValue)_bg")
                    .resizable()
                    .scaledToFill()
            }
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.bind()
        }
    }
}

extension RoverView {
    public var dragGesture: some Gesture {
        DragGesture(minimumDistance: 50, coordinateSpace: .global)
            .onChanged { value in
                withAnimation(.smooth(duration: 0.6, extraBounce: 0.3)) {
                    if galleryViewHeight >= UIScreen.height * 0.1 {
                        galleryViewHeight = lastHeight - value.translation.y
                        currentHeight = lastHeight - value.translation.y
                    }
                }
            }
            .onEnded {_ in
                withAnimation(.smooth(duration: 0.6, extraBounce: 0.3)) {
                    if currentHeight < UIScreen.height * 0.4 {
                        galleryViewHeight = UIScreen.height * 0.2
                    } else {
                        galleryViewHeight = UIScreen.height * 0.8
                    }
                    lastHeight = galleryViewHeight
                }
            }
    }
}

#Preview {
    RoverView(rover: .curiosity, photoGalleryView: PhotoGalleryView(viewModel: PhotoGalleryViewModel(for: .curiosity)))
}
