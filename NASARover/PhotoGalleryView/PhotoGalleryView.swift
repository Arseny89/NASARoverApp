//
//  PhotoGalleryView.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/25/24.
//

import SwiftUI
import SwiftData

struct PhotoGalleryView: View {
    @StateObject var viewModel: PhotoGalleryViewModel
    private let columns = [
        GridItem(.adaptive(minimum: 80)),
        GridItem(.adaptive(minimum: 80)),
        GridItem(.adaptive(minimum: 80))
    ]
    
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
                        PhotoGalleryCell(photoData: photoData, viewModel: viewModel)
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
            if let uiImageData = viewModel.selectedPhotoData, let uiImage = UIImage(data: uiImageData) {
                DetailedView(photoData: viewModel.photoData,
                             photo: uiImage,
                             inFavorites: $viewModel.inFavorites)
                .presentationBackground(.black.opacity(0.7))
            }
        })
        .ignoresSafeArea(.all)
    }
}

struct PhotoGalleryCell: View {
    var photoData: PhotoData
    @ObservedObject var viewModel: PhotoGalleryViewModel
    @Query private var photos: [Photo]
    
    var body: some View {
        ZStack {
            if let cachedUiImage = viewModel.getCachedImage(for: String(photoData.id)) {
                Image(uiImage: cachedUiImage)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        viewModel.selectedPhotoData = cachedUiImage.jpegData(compressionQuality: 1.0)
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
    
    private func checkFavorites() {
        if photos.compactMap({ $0.photoData?.imageURL }).contains(viewModel.photoData?.imageURL) {
            viewModel.inFavorites = true
        } else {
            viewModel.inFavorites = false
        }
    }
}

extension View {
    func hiddenIf(_ isHidden: Bool) -> some View {
        isHidden ? AnyView(self.hidden()) : AnyView(self)
    }
}
