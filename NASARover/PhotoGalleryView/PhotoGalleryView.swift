//
//  PhotoGalleryView.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/25/24.
//

import SwiftUI
import SwiftData

struct PhotoGalleryView: View {
    @ObservedObject var viewModel: PhotoGalleryViewModel
    private let columns = [
        GridItem(.adaptive(minimum: 80)),
        GridItem(.adaptive(minimum: 80)),
        GridItem(.adaptive(minimum: 80))
    ]
    @Query private var photos: [Photo]
    
    var body: some View {
        VStack {
            VStack {
                Rectangle()
                    .frame(width: UIScreen.width * 0.3, height: 5)
                    .clipShape(.capsule)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                Spacer()
            }
            .height(20)
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.photos.sorted { $1.0 < $0.0 }, id: \.key) { key, photoData in
                        ZStack {
                            if let cachedImage = viewModel.getCachedImage(for: String(photoData.id)) {
                                Image(uiImage: cachedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture {
                                        viewModel.detailedURL = photoData.imageURL
                                        viewModel.photoData = photoData
                                        viewModel.presentDetailedView = true
                                        checkFavorites()
                                    }
                            } else {
                                ProgressView()
                                    .onAppear {
                                        viewModel.fetchImage(for: photoData) { _ in }
                                    }
                            }
                        }
                        .frame(width: 120, height: 120)
                    }
                }
                Button {
                    viewModel.bind()
                } label: {
                    Text(Titles.showMoreButton.rawValue.capitalized)
                        .font(.system(size: 15, weight: .bold))
                }
                .frame(width: 200, height: 30)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipCapsule()
                .padding(.vertical, 30)
                
            }
            .ignoresSafeArea(.all)
        }
        .fullScreenCover(isPresented: $viewModel.presentDetailedView, content: {
            DetailedView(detailedURL: $viewModel.detailedURL, photoData: $viewModel.photoData, inFavorites: $viewModel.inFavorites)
                .presentationBackground(.black.opacity(0.7))
        })
        .ignoresSafeArea(.all)
    }
    
    private func checkFavorites() {
        if photos.compactMap({ $0.url }).contains(viewModel.photoData?.imageURL) {
            viewModel.inFavorites = true
        } else {
            viewModel.inFavorites = false
        }
    }
}

struct DetailedView: View {
    @Binding var detailedURL: URL?
    @Binding var photoData: PhotoData?
    @Binding var inFavorites: Bool
    @Query private var photos: [Photo]
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var modelContext
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    @State private var currentOffset = CGPoint.zero
    @State private var previousOffset = CGPoint.zero
    @State private var scaleButtonPressed: CGFloat = 1
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if let photoData {
                    VStack(alignment: .leading) {
                        Text("Date: \(photoData.date) (Sol: \(photoData.sol))")
                        Text("\(photoData.camera.fullName)")
                    }
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                }
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(icon: .xmark)
                        .resizable()
                        .scaledToFill()
                        .frame(20)
                        .foregroundColor(.white)
                        .shadow(1, offset: 5.0, angle: .bottomTrailing)
                }
                .padding(.trailing, 10)
            }
            ScrollView {
                AsyncImage(url: detailedURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .scaleEffect(currentZoom + totalZoom)
                .gesture(
                    SimultaneousGesture(
                        MagnifyGesture()
                            .onChanged { value in
                                currentZoom = (value.magnification - 1) * (totalZoom * 0.5)
                            }
                            .onEnded { value in
                                totalZoom += currentZoom
                                currentZoom = 0
                                if totalZoom < 1 {
                                    totalZoom = 1
                                    withAnimation {
                                        currentOffset = .zero
                                    }
                                }
                            },
                        
                        DragGesture(minimumDistance: 10, coordinateSpace: .global)
                            .onChanged { value in
                                if totalZoom > 1 {
                                    currentOffset.y = previousOffset.y + value.translation.y
                                    currentOffset.x = previousOffset.x + value.translation.x
                                }
                            }
                            .onEnded { value in
                                previousOffset = currentOffset
                            }
                    )
                )
                .accessibilityZoomAction { action in
                    if action.direction == .zoomIn {
                        totalZoom += 0.5
                    } else {
                        totalZoom -= 0.5
                    }
                }
                .offset(currentOffset)
                .background(Color.white.opacity(0.9))
                .border(Color.white.opacity(0.9), width: 5)
                .cornerRadiusIf(true, 5)
                
            }
            .scaledToFit()
            .scrollDisabled(true)
            Button {
                saveImage()
            } label : {
                Image(icon: .add)
                    .resizable()
                    .scaledToFill()
                    .frame(20)
                    .foregroundColor(.white)
                Text("Add")
                    .foregroundColor(.white)
            }
            .frame(width: 100, height: 30)
            .background(.blue)
            .foregroundColor(.white)
            .clipCapsule()
            .padding(.leading, 10)
            .scaleEffect(scaleButtonPressed)
            .hiddenIf(inFavorites)
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
    
    private func saveImage() {
        if let photoData {
            URLSession.shared.dataTask(with: photoData.imageURL) { data, response, error  in
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    modelContext.insert(
                        Photo(
                            rover: photoData.rover.name,
                            url: photoData.imageURL,
                            data: imageData,
                            date: photoData.date,
                            sol: photoData.sol,
                            camera: photoData.camera.fullName
                        )
                    )
                    if photos.compactMap({ $0.url }).contains(photoData.imageURL) {
                        inFavorites = true
                    } else {
                        inFavorites = false
                    }
                }
            }
            .resume()
        }
    }
}

extension View {
    func hiddenIf(_ isHidden: Bool) -> some View {
        isHidden ? AnyView(self.hidden()) : AnyView(self)
    }
}
